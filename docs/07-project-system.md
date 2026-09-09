# 7. Project System

In Pulsar, a **project** is a unit of code identified by a Metacello **baseline** (e.g., `BaselineOfPulsar`). This is different from Pharo's traditional concept of "projects as a set of packages" — a Pulsar project is defined by its baseline, which declares its dependencies, groups, and package membership.

## What is a Project?

A project in Pulsar corresponds to a Metacello baseline class. For example:
- `BaselineOfPulsar` → the `Pulsar` project
- `BaselineOfSpecGtk` → the `SpecGtk` project
- `BaselineOfIceberg` → the `Iceberg` project

Each baseline declares:
- Packages that compose the project
- Dependencies on other baselines
- Load groups for selective installation

## PulsarBaseProjectModel

```smalltalk
PvBaseModel subclass: #PulsarBaseProjectModel
    package: 'Pulsar-Browser'
```

Abstract base for all project models. It provides:

| Method | Purpose |
|---|---|
| `name` | The project name (concrete subclasses define how to obtain it) |
| `children` | Subclass responsibility |
| `dependencyModels` | Models for dependent projects (empty on the base class) |
| `addPackageNamed:` | Adds a package to the project |
| `isProject` | Returns `true` (for type checks) |
| `isVolatileProject` | Returns `false` (overridden by volatile projects) |
| `parentModel` | Always `nil` — "in pulsar metamodel, projects do not have parent" |
| `pulsarEditorClass` | `PulsarProjectEditor` |

The underlying `BaselineOf...` class is stored in the inherited `entity` slot; `PulsarProjectModel >> baselineClassModel` wraps it in a `PvClassModel` when needed.

### Project Models in the Tree

Projects are held by a `PulsarMultiProjectModel`, obtained from the environment model via `newMultiProjectModel`:

```
PvEnvironmentModel
  └── PulsarMultiProjectModel          (via newMultiProjectModel)
        ├── PulsarProjectModel (BaselineOfPulsar)
        │     └── PvPackageModel 'Pulsar-Browser'
        │     └── PvPackageModel 'Pulsar-Tool-Repositories'
        ├── PulsarProjectModel (BaselineOfSpecGtk)
        │     └── ...
        ├── PulsarProjectModel (BaselineOfIceberg)
        │     └── ...
        └── PulsarVolatileProjectModel (no baseline)
              └── PvPackageModel ...
```

Note that `PulsarProjectModel >> children` returns only the **package models** — dependencies are deliberately excluded (there is a comment in the source explaining that dependencies were not used in practice).

## PulsarProjectModel

```smalltalk
PulsarBaseProjectModel subclass: #PulsarProjectModel
    slots: { baselineClass. repositoryModel }
    package: 'Pulsar-Browser'
```

Concrete project model for installed baselines. It holds:
- `baselineClass`: the `BaselineOf...` class (also the `entity`)
- `repositoryModel`: the repository model the project is loaded from, if any

`name` strips the `BaselineOf` prefix (`^ self entity name allButFirst: 10 "BaselineOf"`), and `children` answers the package models collected from the baseline (`collectPackageModels`). Dependencies are resolved on demand by `dependencyModels` (via the Metacello project version).

## PulsarMultiProjectModel

```smalltalk
PvBaseModel subclass: #PulsarMultiProjectModel
    slots: { projectModels }
    package: 'Pulsar-Browser'
```

The container of all project models (both baseline-backed and volatile). Its `children` answers `projectModels`. It is obtained from the environment model via `newMultiProjectModel`, and provides navigation helpers such as `findRootForEntity:`, `findPathForClass:`, `addProject:`, `removeProjectModel:`, `ensureVolatileProjectNamed:`, `replaceVolatileProject:withBaseline:`, and `initializeVolatileProjects` (which materializes the persisted `PulsarVolatileProjectSpec` registry on browser start).

## PulsarVolatileProjectModel

```smalltalk
PulsarBaseProjectModel subclass: #PulsarVolatileProjectModel
    slots: { packageModels }
    package: 'Pulsar-Browser'
```

Represents a project without a baseline. `isVolatileProject` answers `true` and `name` answers the entity (a plain name string). `packageModels` holds the packages organized under the project. These models are materialized from `PulsarVolatileProjectSpec` instances when the browser starts (see below).

## PulsarVolatileProjectSpec

```smalltalk
Object subclass: #PulsarVolatileProjectSpec
    slots: { name. packageNames }
    sharedVariables: { VolatileProjectSpecs }
    package: 'Pulsar-Browser'
```

A lightweight registry entry for a volatile project that survives image restarts: it stores only a name and package names. The class side provides `specs`, `registerProjectNamed:packageNames:`, `unregisterProjectNamed:`, and `named:`; `PulsarMultiProjectModel >> initializeVolatileProjects` materializes `PulsarVolatileProjectModel` instances from these specs.

## PulsarBaselineMapBuilder

```smalltalk
RSThemedMapBuilder subclass: #PulsarBaselineMapBuilder
    slots: { isDarkTheme }
    package: 'Pulsar-Browser'
```

Roassal map builder that provides the theme (colors, backgrounds, selection/text colors) for the baseline dependency map. Dependency resolution itself is done by the models (`PulsarProjectModel >> dependencyModels` via Metacello); the map is rendered by `PulsarProjectBaselineMapPresenter` and `PulsarProjectDependenciesPresenter`.

## Project View

```smalltalk
PulsarBaseProjectView subclass: #PulsarProjectView
    package: 'Pulsar-Browser'
```

The panel that renders the project tree in the main browser. It displays:
- Installed projects (with their packages)
- Volatile projects
- A root node for multi-project browsing

```smalltalk
PulsarBaseProjectView subclass: #PulsarSingleProjectView
    traits: { PulsarTEditor }
    package: 'Pulsar-Browser'
```

A focused view of a single project's structure (its packages as tree roots). Both views extend `PulsarBaseProjectView`, which in turn extends `PulsarBaseView` and provides the shared tree, filtering, and event infrastructure.

## Project Actions

Projects contribute actions through the standard `<dockActions>` pragma mechanism:

```smalltalk
PulsarBaseProjectModel >> defineActionsOn: aBuilder
    <dockActions>

    aBuilder addGroup: #tools with: [ :group | group
        name: 'Tools';
        beDisplayedAsGroup;
        priority: 900;
        addActionWith: [ :action | action
            name: 'Browse in panel';
            iconName: 'project';
            description: 'Open this project in a focused panel';
            action: [ :aContext |
                aContext notificationCenter announce: (PulsarRequestProjectAnnouncement on: self) ] ] ]
```

`PulsarBaseProjectModel` also contributes a `#operationCritical` group ("DANGER ZONE", "Close project") via `defineCriticalActionsOn:`, and `PulsarVolatileProjectModel` adds a "Create baseline" action via `defineCreateBaselineActionOn:`.

## Project-Related Classes

| Class | Purpose |
|---|---|
| `PulsarProjectRenameModel` | `PulsarModelVisitor` that renames the visited class models (used by project-driven bulk operations) |
| `PulsarProjectRemoveModel` | `PulsarModelVisitor` that removes the visited class models |
| `PulsarPackageDependencyModel` | Computed view model for package-level dependencies (direction `#outgoing`/`#incoming`) |
| `PulsarProjectNodeRow` | Row presenter for the project tree |

## Repository Projects

The `Pulsar-Tool-Repositories` package has its own project integration:

```smalltalk
SpPresenter subclass: #PulsarRepositoryProjectDialog
    package: 'Pulsar-Tool-Repositories'
```

A dialog to pick the source directory and format (e.g. FileTree) of a project, used by the repository repair tools (`PulsarRepositoryRepairProject`, `PulsarRepositoryRepairEditRepository`).

## Key Classes

| Class | Package | Role |
|---|---|---|
| `PulsarBaseProjectModel` | Pulsar-Browser | Abstract project model |
| `PulsarProjectModel` | Pulsar-Browser | Loaded (baseline-backed) project model |
| `PulsarMultiProjectModel` | Pulsar-Browser | Container of all project models |
| `PulsarVolatileProjectModel` | Pulsar-Browser | Project without a baseline |
| `PulsarVolatileProjectSpec` | Pulsar-Browser | Persisted registry entry for volatile projects |
| `PulsarBaselineMapBuilder` | Pulsar-Browser | Theme for the baseline dependency map |
| `PulsarProjectView` | Pulsar-Browser | Project browser panel |
| `PulsarSingleProjectView` | Pulsar-Browser | Single project focused view |
| `PulsarProjectBaselineMapPresenter` | Pulsar-Browser | Baseline map presenter |
| `PulsarProjectDependenciesPresenter` | Pulsar-Browser | Dependency tree presenter |
