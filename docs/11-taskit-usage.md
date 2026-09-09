# 11. TaskIt Usage — `scheduleTask:`, `scheduleJob:`, `queueTask:`

All background work in Pulsar must go through **TaskIt**, a Pharo concurrency framework. Pulsar provides three dispatching methods, each suited to different workloads.

## Quick Reference

| Method | Backend | Concurrency | Ordering | Visual Feedback |
|---|---|---|---|---|
| `scheduleTask:` | `PulsarTTaskScheduler` (pool of 5) | Parallel | Non-FIFO | None |
| `scheduleJob:` | Wraps `scheduleTask:` + spinner | Parallel | Non-FIFO | Statusbar spinner |
| `queueTask:` | `PulsarTTaskWorker` (single worker) | Sequential | FIFO | None |

**Where the methods live:** `scheduleTask:` and `scheduleJob:` come from `PulsarTTaskScheduler`/`PulsarTJobHandler`, composed by browsers and windows. `queueTask:` comes from `PulsarTTaskWorker`, composed only where ordering matters (the class outline view, the versions browser, the transcript, the task announcer). Views reach scheduling through the action context, which forwards to their window: `PulsarActionContext >> scheduleTask:`/`scheduleJob:`.

## `scheduleTask:` — Parallel, Independent Work

```smalltalk
PulsarTTaskScheduler >> scheduleTask: aBlock
    ^ self taskScheduler schedule: aBlock
```

Dispatches `aBlock` to a pool of **5 workers**. Tasks execute concurrently and in no guaranteed order.

**When to use:**
- Loading data from the environment (packages, classes)
- Searching or filtering large collections
- Independent computations that don't share mutable state
- Any work where order doesn't matter

**Example:**
```smalltalk
"Load package children in the background"
self scheduleTask: [
    | packages |
    packages := self environmentModel allPackages.
    self notificationCenter announce: (PackagesLoadedAnnouncement new packages: packages) ]
```

**Pool configuration:**
```smalltalk
PulsarTTaskScheduler >> taskSchedulerPoolSize
    ^ 5

PulsarTTaskScheduler >> newTaskScheduler
    ^ TKTWorkerPool new
        name: self className;
        poolMaxSize: self taskSchedulerPoolSize;
        start
```

The pool is lazily created on first use and must be purged on close.

## `scheduleJob:` — User-Initiated Work with Feedback

```smalltalk
PulsarBaseBrowser >> scheduleJob: aBlock
    self scheduleTask: [
        self jobStart.
        [ aBlock cull: self statusbar ]
        ensure: [
            self statusbar clearMessage.
            self jobEnd ] ]
```

Wraps `scheduleTask:` with automatic **statusbar spinner** management. The block receives the statusbar presenter as an optional argument (`cull:`), so it can post progress messages.

**When to use:**
- User clicks a button that does work
- Loading dependencies, fetching remotes
- Any action where the user should see that something is happening

**Example:**
```smalltalk
self scheduleJob: [ :statusbar |
    statusbar pushMessage: 'Fetching remote...'.
    self repository fetch.
    statusbar popMessage.
    statusbar pushMessage: 'Updating branches...'.
    self repository refreshBranches.
    statusbar popMessage ]
```

**How the spinner works:**

`PulsarTJobHandler` manages the `job` instance variable:

```smalltalk
PulsarTJobHandler >> jobStart
    job ifNil: [ job := PulsarJobHandler on: self ].
    job start

PulsarTJobHandler >> jobEnd
    job ifNil: [ ^ self ].
    job end
```

`PulsarJobHandler` adds a spinner to the statusbar on `start` and removes it on `end` (counting nested jobs so the spinner survives reentrant schedules). It does **not** announce anything.

In addition, the browser subscribes to the standard Pharo `JobStart`/`JobEnd` announcements. This catches jobs that are *not* launched through `scheduleJob:` — for example an `IceExternalJob` spawned by Iceberg — and shows the same spinner for them:

```smalltalk
PulsarBaseBrowser >> registerToSystemEvents
    self announcer
        when: JobStart send: #eventJobStart: to: self;
        when: JobEnd send: #eventJobEnd: to: self;
        "excerpt: also resends SystemAnnouncement and MetacelloExecutionAnnouncement"
        when: SystemAnnouncement, MetacelloExecutionAnnouncement
            send: #resendAnnouncement: to: self

PulsarBaseBrowser >> eventJobStart: anAnnouncement
    self jobStart

PulsarBaseBrowser >> eventJobEnd: anAnnouncement
    self jobEnd
```

## `queueTask:` — Sequential, Ordered Work

```smalltalk
PulsarTTaskWorker >> queueTask: aBlock
    "Tasks execute in FIFO order on a single worker."
    ^ self taskWorker schedule: aBlock
```

Dispatches `aBlock` to a **single worker**. Tasks execute one at a time, in FIFO order.

**When to use:**
- Sequential repository operations (fetch then checkout then merge)
- Any work where order must be preserved
- Operations that must not interleave

**Example:**
```smalltalk
"Checkout a branch, then refresh the commit list"
self queueTask: [
    self repository checkoutBranch: branchName.
    self notificationCenter announce: CommitsRefreshed new ]
```

**Worker configuration:**
```smalltalk
PulsarTTaskWorker >> newTaskWorker
    ^ PulsarWorker new
        inTool: self class;
        start
```

## PulsarWorker

```smalltalk
PulsarWorker
    superclass: #TKTWorker
    package: 'Pulsar-Browser'
```

A `TKTWorker` subclass with one Pulsar-specific addition:

```smalltalk
PulsarWorker >> inTool: aClass
    ^ self name: ('{TOOL}-{ID}' format: { #TOOL -> aClass name. #ID -> UUID new } asDictionary)
```

`inTool:` records which tool class owns the worker, so running workers can be attributed for debugging and monitoring.

## PulsarTaskAnnouncer

```smalltalk
PulsarTaskAnnouncer
    package: 'Pulsar-Browser'
```

A specialized announcer that ensures announcements fired from background workers are delivered on the **UI thread**. This avoids GTK thread-safety issues:

```smalltalk
"My background task can safely announce:"
self scheduleTask: [
    | result |
    result := self doExpensiveComputation.
    self notificationCenter announce: (MyResultAnnouncement with: result) ]
```

`PulsarTaskAnnouncer` handles the thread transition transparently.

**Mechanism:** `PulsarTaskAnnouncer` composes `PulsarTTaskWorker`, so `announce:` queues the actual delivery on its single FIFO worker via `queueTask:`. Two exceptions bypass the queue and announce synchronously: while announcements are suspended (`isSuspended`), and for the synchronous classes listed in `synchronicAnnouncements` (`SpWindowWillClose`, `PulsarModelDeactivated`).

## UI Thread Updates

If you need to update the UI from a background task, announce an event rather than calling presenter methods directly. The presenter subscribes to the announcement and updates itself on the UI thread.

**Wrong:**
```smalltalk
self scheduleTask: [
    self presenter updateList: items ]  "NOT thread-safe!"
```

**Right:**
```smalltalk
self scheduleTask: [
    | items |
    items := self loadItems.
    self notificationCenter announce: (ItemsUpdatedAnnouncement new items: items) ]
```

## Cleanup

Always purge schedulers and workers when the owning presenter closes. The browser does this automatically:

```smalltalk
PulsarBaseBrowser >> windowClosed
    self presenters do: [ :each | each windowClosed ].
    self cleanUpSchedulers.
    super windowClosed

PulsarBaseBrowser >> cleanUpSchedulers
    announcer ifNotNil: #purgeTaskWorker.
    self purgeTaskScheduler
```

```smalltalk
PulsarTTaskScheduler >> purgeTaskScheduler
    taskScheduler ifNil: [ ^ self ].
    taskScheduler purge.
    taskScheduler stop.
    taskScheduler := nil

PulsarTTaskWorker >> purgeTaskWorker
    taskWorker ifNil: [ ^ self ].
    taskWorker purge.
    [ taskWorker currentTaskExecution ifNotNil: #cancel ]
        on: Error do: [ :e | logger info: 'Task was already cancelled but we do not care.' ].
    taskWorker stop.
    taskWorker := nil
```

## Decision Flowchart

```
Need to do background work?
    │
    ├── User-initiated action? ──► Use scheduleJob: (spinner + feedback)
    │
    ├── Operations must be ordered? ──► Use queueTask: (FIFO, single worker)
    │
    ├── Independent and parallelizable? ──► Use scheduleTask: (pool of 5)
    │
    └── Just a quick synchronous call? ──► Don't TaskIt, just send the message
```

## Common Patterns

### Fire and Forget
```smalltalk
self scheduleTask: [ self doBackgroundWork ]
```

### With Result Announcement
```smalltalk
self scheduleTask: [
    | result |
    result := self compute.
    self notificationCenter announce: (ResultReady new result: result) ]
```

### Sequential Repository Operations
```smalltalk
self queueTask: [
    repository fetch.
    repository pull.
    self notificationCenter announce: PulsarRepositoryModified new ]
```

### User Action with Progress
```smalltalk
self scheduleJob: [ :statusbar |
    statusbar pushMessage: 'Processing...'.
    [ self doWork ] ensure: [
        statusbar popMessage ] ]
```
