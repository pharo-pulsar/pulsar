# 3. Trait-Based Infrastructure

Pulsar uses **traits** as a primary composition mechanism. Rather than deep inheritance chains, reusable behaviors — scheduling, snapshots, notification routing, job feedback, editor protocol — are packaged as traits and mixed into presenters and models.

This chapter describes each trait, its slot, its purpose, and where it is used.

## Trait Summary

| Trait | Slot | Purpose | Used by |
|---|---|---|---|
| `PulsarTSnapshot` | — | `snapshot` method | Presenters, browsers, windows |
| `PulsarTTaskScheduler` | `taskScheduler` | Parallel independent work (pool of 5) | Browsers, windows |
| `PulsarTTaskWorker` | `taskWorker` | Sequential FIFO work (single worker) | Presenters that need ordered operations |
| `PulsarTNotificationCenter` | `notificationCenter` | Delegating announcer for announcements | Presenters |
| `PulsarTJobHandler` | `job` | Statusbar spinner during async work | Browsers, windows |
| `PulsarTEditor` | — | Editor identification (`isEditor`, `canBeListed`, `isEmbedded`) | Editor presenters |
| `PulsarTControlUpdate` | `updating` | Guard against re-entrant UI updates | Presenters |
| `PulsarTModelSnapshot` | — | `prepareForSnapshot` cleanup hook | Models |
| `PulsarTModelVisitor` | — | Model visitor protocol | Models |
| `PulsarTModelEditable` | — | Editor class access for models | Editor-backed models |
| `PulsarTGlobalActionContainer` | `globalActions` | Action collection for presenters | Presenters |
| `PulsarTEnvironmentModel` | `environmentModel` | Environment access for models | Models |
| `PulsarTPanelWindow` | `lastTimePresented`, `panelPosition`, `pinned`, `actions` | Panel positioning and pinning | Views |
| `PulsarTPopover` | — | Popover support | Presenters |

---

## PulsarTSnapshot

Provides the `snapshot` method used to serialize presenter state for image persistence.

```smalltalk
PulsarTSnapshot >> snapshot
    ^ PulsarPanelSnapshot on: self
```

Every presenter that needs to survive an image restart composes this trait (or inherits it, e.g. through `PulsarBaseView`). Restoration is performed by the snapshot object itself via `restoreTo:` — see chapter 8.

**Where used:** `PulsarBaseView` (and its subclasses, e.g. `PulsarEditor`), `PulsarBaseWindow`, `PulsarBaseBrowser`, `PulsarClassOutlineView`, `PulsarTranscript`, `PulsarVersionsBrowser`, `PulsarWindowPresenter`, ...

---

## PulsarTTaskScheduler

Provides a pool of **5 workers** for parallel, non-FIFO background work.

```smalltalk
"Slot: taskScheduler"

PulsarTTaskScheduler >> scheduleTask: aBlock
    ^ self taskScheduler schedule: aBlock

PulsarTTaskScheduler >> newTaskScheduler
    ^ TKTWorkerPool new
        name: self className;
        poolMaxSize: self taskSchedulerPoolSize;  "returns 5"
        start

PulsarTTaskScheduler >> purgeTaskScheduler
    taskScheduler ifNil: [ ^ self ].
    taskScheduler purge.
    taskScheduler stop.
    taskScheduler := nil
```

**Key rules:**
- Use `scheduleTask:` for independent, unordered background work (e.g., loading data, searching).
- The pool size of 5 means up to 5 tasks can run concurrently.
- Always call `purgeTaskScheduler` when the owner closes (done automatically by `PulsarBaseBrowser>>#windowClosed`).

**Where used:** `PulsarBaseWindow`, `PulsarBaseBrowser`, `PulsarWindowPresenter`.

---

## PulsarTTaskWorker

Provides a **single FIFO worker** for ordered, sequential background work.

```smalltalk
"Slot: taskWorker"

PulsarTTaskWorker >> queueTask: aBlock
    "Tasks execute in FIFO order on a single worker."
    ^ self taskWorker schedule: aBlock

PulsarTTaskWorker >> newTaskWorker
    ^ PulsarWorker new
        inTool: self class;
        start

PulsarTTaskWorker >> purgeTaskWorker
    taskWorker ifNil: [ ^ self ].
    taskWorker purge.
    [ taskWorker currentTaskExecution ifNotNil: #cancel ]
        on: Error do: [ :e | logger info: 'Task was already cancelled but we do not care.' ].
    taskWorker stop.
    taskWorker := nil
```

**Key rules:**
- Use `queueTask:` when operations must be ordered (e.g., sequential repository fetches).
- Tasks wait in a queue and execute one at a time.
- `PulsarWorker` extends TKT workers with Pulsar-specific metadata (`inTool:`).

**Where used:** `PulsarClassOutlineView`, `PulsarRepositoryDiffEditor`, `PulsarTaskAnnouncer`, `PulsarTranscript`, `PulsarVersionsBrowser`.

---

## PulsarTNotificationCenter

Provides a delegating announcer that can be swapped at runtime.

```smalltalk
"Slot: notificationCenter"

PulsarTNotificationCenter >> notificationCenter
    ^ notificationCenter

PulsarTNotificationCenter >> notificationCenter: anAnnouncer
    self basicNotificationCenter: anAnnouncer
```

The slot holds a `PulsarNotificationCenterDelegate` (or a real `Announcer`). When it holds a delegate, all announce/subscribe calls are forwarded to the delegate's `target`. This allows:

- **Embedded views** to use their parent's announcer instead of creating their own.
- **Browsers** to swap the underlying announcer without re-registering all subscribers.

```smalltalk
"Bind a presenter's notification center to its parent browser"
PulsarTNotificationCenter >> registerToBrowser: aPulsarBrowser
    self notificationCenter: aPulsarBrowser notificationCenter
```

**Where used:** `PulsarBaseView` (and therefore all views, e.g. `PulsarEditor`), `PulsarSpotter`, `PulsarInspector`, `PulsarVersionsBrowser`, `PulsarMessageBrowser`, ... Note that `PulsarBaseBrowser` does not use the trait: it implements `notificationCenter` directly as `^ self announcer`.

---

## PulsarTJobHandler

Shows a **statusbar spinner** while async work is in progress.

```smalltalk
"Slot: job"

PulsarTJobHandler >> jobStart
    job ifNil: [ job := PulsarJobHandler on: self ].
    job start

PulsarTJobHandler >> jobEnd
    job ifNil: [ ^ self ].
    job end
```

The browser's `scheduleJob:` combines `scheduleTask:` with `jobStart`/`jobEnd`:

```smalltalk
PulsarBaseBrowser >> scheduleJob: aBlock
    self scheduleTask: [
        self jobStart.
        [ aBlock cull: self statusbar ]
        ensure: [
            self statusbar clearMessage.
            self jobEnd ] ]
```

**Where used:** `PulsarBaseBrowser`, `PulsarBaseWindow`, `PulsarVersionsBrowser`, `PulsarWindowPresenter`. The trait also declares `addStatusbarPresenter:` / `removeStatusbarPresenter:` as subclass responsibilities, implemented by the windows that install a statusbar.

---

## PulsarTEditor

Marks a presenter as an editor and provides editor identification.

Provides:
- `isEditor` — answers `true`
- `canBeListed` — whether the editor can be listed in the editor stack
- `isEmbedded` — whether the editor is not contained directly into a panel widget

The actual editing infrastructure (dirty tracking, toolbar, save/cancel, snapshots) is implemented by `PulsarEditor` itself, not by this trait — see chapter 13.

**Where used:** `PulsarEditor` and its subclasses (`PulsarClassEditor`, `PulsarMethodEditor`, `PulsarPackageEditor`, `PulsarFileEditor`, `PulsarProjectEditor`, etc.), plus other editor-like presenters (`PulsarPreviewEditor`, `PulsarVersionsBrowser`, `PulsarRepositoryDiffEditor`, ...).

---

## PulsarTControlUpdate

Guards against **re-entrant UI updates** during model change propagation.

```smalltalk
"Slot: updating (Boolean)"

PulsarTControlUpdate >> isUpdating
    ^ updating ifNil: [ updating := false ]

PulsarTControlUpdate >> updatingWhile: aBlock
    | oldUpdating |
    oldUpdating := self isUpdating.
    updating := true.
    ^ aBlock ensure: [ updating := oldUpdating ]
```

When a model change triggers a presenter update that itself triggers another change, `updatingWhile:` short-circuits the cycle. Use it in `updatePresenter` and similar methods.

**Where used:** `PulsarEditor`, `PulsarLLMChatConsole`, `PulsarRepositoriesView`, `PvEditorView`.

---

## PulsarTGlobalActionContainer

Lazily collects global actions for a presenter.

```smalltalk
"Slot: globalActions"

PulsarTGlobalActionContainer >> globalActions
    ^ globalActions ifNil: [ globalActions := PulsarActionCollector collectFor: self ]
```

**Where used:** `PulsarBaseBrowser`, `PulsarDebuggerInspector`.

---

## Composition Example

Here is how `PulsarEditor` composes multiple traits:

```smalltalk
PulsarBaseView subclass: #PulsarEditor
    slots: {
        toolbarPresenter.
        editorPresenter.
        dirty.
        editorOverlayLayout.
        dirtyMarkerPresenter.
        searchBarPresenter.
        shouldUpdateTitle.
        updating }
    uses: PulsarTControlUpdate + PulsarTEditor
    package: 'Pulsar-Browser'
```

And `PulsarBaseWindow`:

```smalltalk
SpPresenter subclass: #PulsarBaseWindow
    slots: { model. taskScheduler. job }
    uses: SpTModel + PulsarTSnapshot + PulsarTTaskScheduler + PulsarTJobHandler
    package: 'Pulsar-Browser'
```

## Choosing Traits vs. Inheritance

| Use a trait when... | Use inheritance when... |
|---|---|
| Behavior is shared across unrelated classes | Classes share a common identity |
| Multiple behaviors need to be mixed into one class | There's a clear "is-a" relationship |
| The behavior is opt-in/optional | The behavior is universal for all subtypes |

Pulsar prefers traits for **infrastructure** (scheduling, snapshots, notifications) and inheritance for **identity** (`PulsarBaseView` → `PulsarEditor` → `PulsarClassEditor`).
