# 1. General Design: Model-Model-View-Presenter (MMVP)

Pulsar follows a variant of the MVP (Model-View-Presenter) pattern called **MMVP**: Model-Model-View-Presenter. The extra "M" reflects that Pulsar distinguishes between the **domain entity** and the **model** that wraps it for presentation.

## The Four Layers

```
  Domain Entity       — RPackage, Class, IceRepository, FileReference...
        ↑ (wraps)
  Model               — PvBaseModel subclass (presentation metadata, actions, children tree)
        ↑ (binds to)
  Presenter/View      — PulsarBaseView / SpPresenter subclass (renders the model in GTK)
```

The **presenter** holds a reference to the model and observes it for changes. User interactions flow from presenter to model, and model-changes flow back to the presenter.

## Why an Extra Model Layer?

In classic MVP, the model *is* the domain object. In Pulsar, the domain object (an `RPackage`, a `Class`, an `IceRepository`) is **not** a presenter-aware object — it knows nothing about icons, action menus, children navigation trees, or how to be displayed. The `PvBaseModel` subclasses act as an **adapter layer** between raw domain objects and the UI:

- They add **presentation metadata**: icon name, color, title, whether the model can be renamed or removed.
- They form a **tree structure**: each model has a `parentModel`, `children`, and an `environmentModel` (the root `PvEnvironmentModel`).
- They collect **actions**: using `<dockActions>` pragmas, models define what commands are available.
- They decouple the UI from domain changes: models can be refreshed when the underlying entity changes without tearing down the presenter.

## The Model Tree

All models ultimately descend from a single root: `PvEnvironmentModel`. This root model wraps the `PvSystemEnvironment`, which discovers Pharo packages, classes, and projects. From there:

```
PvEnvironmentModel
  ├── PvPackageModel             (all packages)
  │     ├── PvPackageTagModel
  │     │     └── class hierarchy (PvTreeNodeModel)
  │     └── PvVirtualPackageTagModel (virtual tags, e.g. "unclassified")
  └── PulsarMultiProjectModel    (via newMultiProjectModel)
        └── PulsarProjectModel   (BaselineOfPulsar, BaselineOfSpecGtk...)
```

**NOTE:** A key idea is that a `PvSystemEnvironment` will produce a local set of business objects, while a `PvRemoteEnvironment` connects with an external image.

Every model knows its place in the tree via `parentModel` and `children`, and can reach the root via `environmentModel`. (Project models are an exception: they are owned by `PulsarMultiProjectModel` through its `children` collection, with `parentModel = nil`.)

## Communication Patterns

Pulsar uses **announcements** (Pharo's observer/event system) for communication between models and presenters:

| Direction | Mechanism |
|---|---|
| Model → Presenter | Announcements (e.g., `PulsarModelChanged`, `PulsarModelSelected`, `PulsarModelActivated`) |
| Presenter → Model | Direct message sends (the presenter holds a reference to the model) |
| Cross-cutting | Notification center (each browser has an announcer that broadcasts system-wide events) |

A key design rule: **presenters never hold direct references to sibling presenters**. They communicate through the notification center. This keeps views decoupled and replaceable. (Composition is still normal: a presenter holds its *child* widgets, like `PulsarBrowser` holding its outline view.)

## Presenter Hierarchy

```
SpPanelWindowPresenter          — panel/dock container (from Spec-Panel)
  └── PulsarBaseBrowser         — shared browser behavior (actions, scheduling, snapshots)
        ├── PulsarBrowser       — main IDE browser (project panel + class outline)
        ├── PulsarRepositoryBrowser — per-repository dock window (Pulsar-Tool-Repositories)
        ├── PulsarDebugger      — the Pulsar debugger (chapter 20)
        ├── PulsarDetachedBrowser — browser detached from the main window
        └── PulsarTestRunnerBrowser — test runner dock window
```

Windows are represented by `PulsarBaseWindow` (a subclass of `SpPresenter`). Each window can host multiple presenters (docked panels, editor tabs, etc.) managed by the `SpPanelWindowPresenter` panel system.

## Traits as Composition

Pulsar makes heavy use of **traits** to compose reusable behavior into both presenters and models. See chapter 3 for details, but in short: rather than deep inheritance chains, functionality like scheduling, snapshots, notification handling, and job feedback is packaged as traits and mixed into the classes that need them.

## Key Classes to Know

| Class | Package | Role |
|---|---|---|
| `PvBaseModel` | Perspective | Base class for all models |
| `PvEnvironmentModel` | Perspective | Root of the model tree |
| `PulsarBaseView` | Pulsar-Browser | Base class for all views/panels |
| `PulsarBaseBrowser` | Pulsar-Browser | Shared browser behavior |
| `PulsarBrowser` | Pulsar-Browser | Main IDE browser |
| `PulsarApplication` | Pulsar-Browser | Application lifecycle root |
