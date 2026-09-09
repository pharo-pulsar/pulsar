# 5. Application Lifecycle

Pulsar's application runtime lifecycle is managed by `PulsarApplication`. This chapter covers how Pulsar boots, configures the GTK backend, persists state across restarts, and shuts down.

## Entry Points

### CLI

```smalltalk
PulsarCLIApplication
```

`PulsarCLIApplication` is a `ClapApplication` exposing the `pulsar` command. The command-line `pulsar` script (a shell launcher installed by the installer scripts) invokes the image with this command. Its flow is:

1. `execute` → `executeSubcommand`
2. `executeOpen` handles the flags, then calls `runApplication`
3. `runApplication` forks `PulsarApplication basicNew prepareAsStandaloneApplication; initialize; run`

Supported flags: `--reset` (clean snapshot and living processes), `--logLevel` (info|warn|debug|trace), `--logFilterByClass`, `--logFilterByHierarchyOfClass`. A subcommand `pulsar update` runs the updater (chapter 15).

### Programmatic

```smalltalk
PulsarApplication >> start
```

From within a running Pharo image, `start` restores the last snapshot if one exists, otherwise it opens a fresh `PulsarBrowser`:

```smalltalk
PulsarApplication >> start
    | snapshot |

    snapshot := self class lastSnapshot.
    (snapshot isNotNil and: [ snapshot hasRecords ])
        ifTrue: [ snapshot restoreTo: self ]
        ifFalse: [ (PulsarBrowser newApplication: self) open ]
```

From an existing browser you can spawn another window with `PulsarBrowser >> spawnNewBrowser` (`(PulsarBrowser newApplication: self application) open`).

## PulsarApplication

```smalltalk
StPharoApplication subclass: #PulsarApplication
    uses: SgaTApplication
    slots: { #standalone. #suspendAnnouncements }
    sharedVariables: { #InternalProjects }
    package: 'Pulsar-Browser'
```

(`lastSnapshot` and `running` are class instance variables; `InternalProjects` is a class variable.)

`PulsarApplication` extends `StPharoApplication` (the standard Spec application class). It is the **singleton root** that:

- Owns the list of all open windows
- Configures the GTK backend
- Manages snapshot persistence
- Handles the image save/restart cycle

### Startup Sequence

1. `run` — called by the CLI entry point (`runApplication` forks it); it tells the backend to start the event loop (`self backend runOn: self`)
2. Backend configuration: `initializeConfiguration` selects the `#Gtk` backend (GTK4) with a `PulsarGtkConfiguration`
3. `start` — invoked by the backend once the loop is running; restores the snapshot from the previous session if one exists (all windows, panels, and editor state)
4. If no snapshot exists, a fresh `PulsarBrowser` is opened; its `initialize` → `initializeDefaultWorkspace` creates the initial panels
5. The GTK event loop runs

### Window Management

```smalltalk
SpApplication >> windows
    "Returns all open windows"
    ^ windows ifNil: [ windows := Set new ]
```

`windows` is inherited from `SpApplication`. Windows register themselves when they are opened (`open` on the window presenter), so there is no `openWindow:` API in Pulsar. The application tracks all open windows for snapshot purposes (`PulsarApplicationSnapshot >> snapshot:` collects from `anApplication windows`).

## PulsarGtkConfiguration

```smalltalk
StPharoGtkConfiguration subclass: #PulsarGtkConfiguration
    package: 'Pulsar-Browser'
```

Configures GTK-specific settings:
- CSS theme loading
- Dark/light/system theme selection (`PulsarSettings`, announced via `PulsarThemeChanged` and `PulsarSyntaxHighlightThemeChanged`)
- Adwaita integration (`AdwStyleManager`)
- Custom user CSS: `pulsar-custom-style.css` and `pulsar-custom-style/*.css` in the image directory
- Font and appearance settings

GTK is configured early in the boot sequence, before any windows are created.

## Image Save and Restart

When the user saves the image (Ctrl+S or menu action), Pulsar persists the entire UI state:

```smalltalk
PulsarBaseBrowser >> saveImage
    [ Smalltalk snapshot: true andQuit: false ] fork.
    self inform: 'Image saved'
```

Before the snapshot writes, each window and presenter calls `snapshot` to serialize its state. The application collects all window snapshots:

```smalltalk
PulsarApplicationSnapshot >> snapshot: anApplication
    records := anApplication windows
        reject: [ :each | each isPopover ]
        thenCollect: [ :each | each snapshot ]
```

On next startup, the application restores:

```smalltalk
PulsarApplicationSnapshot >> restoreTo: anApplication
    anApplication suspendAnnouncementsDuring: [
        (records sorted: #restorePriority ascending)
            collect: [ :each | self restoreWindow: each to: anApplication ]
            thenDo: [ :each | each open ] ]

PulsarApplicationSnapshot >> restoreWindow: aSnapshot to: anApplication
    | window |
    window := aSnapshot instantiateOn: anApplication.
    window notificationCenter
        suspendAllWhile: [ aSnapshot restoreTo: window ].
    ^ window
```

**Key points about restore:**
- Snapshots are restored in priority order
- Announcements are suspended during restore to avoid triggering side effects on half-built windows
- Each window is opened after restoration (it then starts receiving events)
- Popovers (modals, dialogs) are NOT snapshotted

## `initializeDefaultWorkspace` vs. `initializeWorkspace`

These two methods serve different purposes:

```smalltalk
"NOT restored from snapshot — called only for fresh sessions"
PulsarBaseBrowser >> initializeDefaultWorkspace
    "Override this to set up initial panels for a fresh browser."

"ALWAYS called — both fresh and restored sessions"
PulsarBaseBrowser >> initializeWorkspace
    "Override this for things that always need to happen (e.g., statusbar init)."
    self initializeStatusbar
```

The distinction matters: `initializeWorkspace` is called from both `initialize` (fresh) and `initializeSnapshot:` (restored). `initializeDefaultWorkspace` is only called from `initialize`.

## Shutdown

When a window closes:

```smalltalk
PulsarBaseBrowser >> windowClosed
    self presenters do: [ :each | each windowClosed ].
    self cleanUpSchedulers.   "stop and nil task scheduler + worker"
    super windowClosed

PulsarBaseBrowser >> cleanUpSchedulers
    announcer ifNotNil: #purgeTaskWorker.
    self purgeTaskScheduler
```

The browser:
1. Notifies all docked presenters of window closure
2. Purges all TaskIt schedulers and workers
3. Stops the announcer's task worker
4. Delegates to super

## Error Handling

```smalltalk
NonInteractiveErrorHandler subclass: #PulsarErrorHandler
    package: 'Pulsar-Browser'
```

Pulsar installs a custom error handler (`ErrorHandler default: PulsarErrorHandler new` during `prepareErrorHandlerAsStandaloneApplication`). It catches unhandled exceptions and submits them to the debugger via `(OupsDebugRequest newForException: anError) submit`, rather than crashing to a Pharo emergency evaluator. It also installs `PulsarUIManager` and a `PulsarSingleDebuggerSelector` as the Oups debugger selection strategy.

## Key Classes

| Class | Package | Role |
|---|---|---|
| `PulsarApplication` | Pulsar-Browser | Application root, singleton |
| `PulsarCLIApplication` | Pulsar-Browser | CLI entry point |
| `PulsarGtkConfiguration` | Pulsar-Browser | GTK backend settings |
| `PulsarApplicationSnapshot` | Pulsar-Browser | Window state serialization |
| `PulsarErrorHandler` | Pulsar-Browser | Unhandled exception handling |
| `PulsarSanityCheck` | Pulsar-Browser | Startup sanity checks |
| `PulsarThemeChanged` | Pulsar-Browser | Announcement for theme changes |
| `PulsarSyntaxHighlightThemeChanged` | Pulsar-Browser | Announcement for syntax theme changes |
