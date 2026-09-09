# 4. The Presenter/Browser Hierarchy

Pulsar's UI is built on **Spec**, Pharo's declarative presenter framework, backed by the **Spec-Gtk** adapter which renders presenters as GTK4 widgets. This chapter covers the presenter class hierarchy and how browsers manage panels.

## The Base Classes

```
SpPresenter                     — abstract presenter (from Spec2)
  ├── PulsarBaseView            — base for all Pulsar views/panels/editors
  │     ├── PulsarEditor        — base for all editors (class, method, file, etc.)
  │     ├── PulsarCollectionView
  │     │     └── PulsarStackView — editor stack panel
  │     ├── PulsarBaseProjectView
  │     │     └── PulsarProjectView — project browser
  │     ├── PulsarClassOutlineView — class outline (instance side, class side, traits)
  │     ├── PulsarPlayground    — playground
  │     └── ... (tool-specific views)
  │
  ├── SpAbstractWidgetPresenter     — widget presenter (from Spec2)
  │     ├── SpPanelWindowPresenter  — a window-level presenter (from Spec-Panel)
  │     │     └── PulsarBaseBrowser — a host for docked panels and editors
  │     │           ├── PulsarBrowser — the main IDE browser
  │     │           ├── PulsarRepositoryBrowser — per-repository dock window
  │     │           ├── PulsarDetachedBrowser — a browser in its own window
  │     │           ├── PulsarDebugger — the Pulsar debugger
  │     │           └── PulsarTestRunnerBrowser — test runner window
  │     └── SpWindowPresenter
  │           └── SpPanelWidgetPresenter — panel docking widget (from Spec-Panel)
  │
  └── PulsarInspector            — object inspector (composes Pulsar traits directly)
```

## PulsarBaseView — Root of All Views

`PulsarBaseView` is the abstract base for every panel, editor, and tool in Pulsar. It extends `SpPresenter` with:

- **Model binding**: implements `setModel:` for binding to a `PvBaseModel`
- **Panel position**: subclasses override `panelPosition` to declare where they dock
- **Notification center**: composed with `PulsarTNotificationCenter`

```smalltalk
PulsarBaseView subclass: #MyToolView
    slots: { }
    uses: PulsarTControlUpdate + PulsarTGlobalActionContainer
    package: 'Pulsar-Tool-MyThing'

MyToolView class >> defaultPanelPosition

    ^ SpPanelPosition endArea
```

### Panel Positions

Positions are declared on the **class side** via `defaultPanelPosition`; the instance-side `panelPosition` (inherited from `PulsarBaseView`) answers `^ self class defaultPanelPosition`.

| Position | Meaning |
|---|---|
| `SpPanelPosition startArea` | Left sidebar (start = left in LTR) |
| `SpPanelPosition endArea` | Right sidebar (end = right in LTR) |
| `SpPanelPosition centerArea` | Main editor area (for editors) |
| `SpPanelPosition bottomArea` | Bottom panel |
| `SpPanelPosition topArea` | Top panel |

## PulsarEditor — Base for Editors

`PulsarEditor` is the abstract base for all code/text editors:

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

Subclasses include:
- `PulsarClassEditor` — class definition editor
- `PulsarMethodEditor` — method source editor
- `PulsarPackageEditor` — package properties editor
- `PulsarProjectEditor` — project/baseline editor
- `PulsarContextEditor` — debugger context editor
- `PulsarFileEditor` — external file editor (in `Pulsar-Tool-FileEditor`)

Editors live in the **center** panel area. Dirty tracking is built into `PulsarEditor` itself (see chapter 13); `PulsarTEditor` only marks them as editors (`isEditor`, `canBeListed`, `isEmbedded`).

## PulsarBaseWindow — The Window

Every top-level window is a `PulsarBaseWindow`:

```smalltalk
SpPresenter subclass: #PulsarBaseWindow
    slots: { model. taskScheduler. job }
    uses: SpTModel + PulsarTSnapshot + PulsarTTaskScheduler + PulsarTJobHandler
    package: 'Pulsar-Browser'
```

It composes:
- `SpTModel` — model binding
- `PulsarTSnapshot` — snapshot support
- `PulsarTTaskScheduler` — background task scheduling
- `PulsarTJobHandler` — statusbar spinner

`PulsarBaseWindow>>#initializeWindow:` configures the GTK window with size tracking, close handling, and global actions.

## PulsarBaseBrowser — The Dock Host

`PulsarBaseBrowser` extends `SpPanelWindowPresenter` with the ability to **manage docked panels and editors**:

```smalltalk
SpPanelWindowPresenter subclass: #PulsarBaseBrowser
    slots: { actions. mutex. model. globalActions. taskScheduler. job }
    uses: { SpTModel. PulsarTSnapshot. PulsarTGlobalActionContainer.
            PulsarTTaskScheduler. PulsarTJobHandler }
    package: 'Pulsar-Browser'
```

The browser implements `notificationCenter` directly as `^ self announcer` (inherited from `Model`), so it does not compose `PulsarTNotificationCenter`.

### Panel Management API

| Method | Purpose |
|---|---|
| `addPresenterClass:` | Instantiate and dock a presenter by class |
| `addPresenterClass:model:` | Same but with a model |
| `addPresenterClass:position:` | Dock at a specific position |
| `addUniquePresenterClass:model:` | Dock only if not already present; raise existing one |
| `addTool:` | Handle a `PulsarRequestToolAnnouncement` |
| `doToggleTool:fromState:` | Toggle a panel open/closed |
| `findPresenterClass:` | Find an existing presenter by class |
| `hasPresenterClass:` | Check if a presenter is already docked |
| `editors` | All presenters in the center area |
| `panels` | All presenters outside the center area |

### Announcement Handling

`PulsarBaseBrowser>>#registerToEvents` wires the browser to its notification center:

```smalltalk
PulsarBaseBrowser >> registerToEvents
    self announcer
        when: PulsarThemeChanged, PulsarSyntaxHighlightThemeChanged, PulsarAnnouncement
            send: #resendAnnouncement: to: self;
        when: PulsarModelActivated send: #eventModelActivated: to: self;
        when: PulsarModelDeactivated send: #eventModelDeactivated: to: self;
        when: PulsarManyModelDeactivated send: #eventManyModelDeactivated: to: self;
        when: PulsarRequestToolAnnouncement send: #addTool: to: self
```

When a `PulsarModelActivated` is received, the browser auto-opens (or focuses) the corresponding editor via `maybeDockView:withActivation:`. When a `PulsarModelDeactivated` is received, the editor is closed.

### Lifecycle

```smalltalk
PulsarBaseBrowser >> initialize
    super initialize.
    self registerToEvents.
    self registerToSystemEvents.
    self initializeDefaultWorkspace

PulsarBaseBrowser >> windowClosed
    self presenters do: [ :each | each windowClosed ].
    self cleanUpSchedulers.   "purges task scheduler and worker"
    super windowClosed

PulsarBaseBrowser >> initializeSnapshot: aSnapshot
    super initialize.
    self registerToEvents.
    self registerToSystemEvents
```

## PulsarBrowser — The Main IDE

```smalltalk
PulsarBaseBrowser subclass: #PulsarBrowser
    slots: { projectView. outlineView }
    package: 'Pulsar-Browser'
```

The main browser has:
- `projectView` — the project panel showing baselines and their packages
- `outlineView` — the class outline (methods, protocols, class side, instance side)

It defines actions via `<dockActions>` pragmas for toggling panels and opening the spotter.

## PulsarRepositoryBrowser — Per-Repository Windows

```smalltalk
PulsarBaseBrowser subclass: #PulsarRepositoryBrowser
    package: 'Pulsar-Tool-Repositories'
```

Each Iceberg repository gets its own browser window with views for branches, commits, diffs, packages, remotes, and repair actions. It declares no slots or traits of its own: background work runs through the scheduling inherited from `PulsarBaseBrowser` (`scheduleTask:`, `scheduleJob:`).

## PulsarDetachedBrowser

A `PulsarDetachedBrowser` is a browser in its own standalone window (not the main IDE window). It has the same panel-hosting capabilities as `PulsarBaseBrowser` but opens as a separate GTK window.

## Presenter Pattern Summary

```
PvEnvironmentModel ──model:──► PulsarBrowser
                                 │  composes
               ┌─────────────────┴──────────────────┐
               ▼                                    ▼
      PulsarProjectView                  PulsarClassOutlineView
  (model: PulsarMultiProjectModel)             │
                                               │ selection
                                               ▼
                                       PulsarModelActivated
                                               │
                                               ▼
                                       PulsarClassEditor
                                       (model: PvClassModel)
```

The data flows **downward** (model → presenter via `model:`) and the interaction flows **upward** (presenter emits announcements → browser reacts → opens/closes editors).
