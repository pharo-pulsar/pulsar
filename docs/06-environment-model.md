# 6. Environment Model

The environment model is how Pulsar discovers and represents the Pharo codebase — packages, classes, methods, and projects. It is the root of the entire model tree.

## PvSystemEnvironment — Low-Level Discovery

`PvSystemEnvironment` is a low-level service that wraps Pharo's system organization:

```smalltalk
PvSystemEnvironment
    package: 'Perspective'
```

It answers questions like:
- What packages exist in the image?
- What classes are in a given package?
- What projects (baselines) are registered with Metacello?

It acts as a **read model** of the Pharo system, providing stable references that the model layer can build upon.

## PvEnvironmentModel — The Model Root

```smalltalk
PvBaseModel subclass: #PvEnvironmentModel
    package: 'Perspective'
```

`PvEnvironmentModel` is the **root model** of every model tree in Pulsar. Every browser has one, and every other model references it via its `environmentModel` slot.

### What It Provides

| Responsibility | Method |
|---|---|
| Root ownership | All models trace back to an environment model |
| Package discovery | `children` returns package models (one per package) |
| Project discovery | `newMultiProjectModel` builds the project models (`allBaselines` forwards to the entity) |
| System navigation | Provided by the browser (`PulsarBaseBrowser >> systemNavigation`), not by the model |
| Updater integration | The model itself receives no announcements (see below) |

### The Environment Model as Anchor

Every model knows its environment:

```smalltalk
PvBaseModel >> environmentModel
    ^ environmentModel

PvBaseModel >> environmentModel: aModel
    environmentModel := aModel
```

This means any model anywhere in the tree can navigate back to the root and discover other parts of the system. It's the primary dependency-injection point: given an environment model, you can reach everything.

## PulsarTEnvironmentModel

A trait that adds environment model access to model classes:

```smalltalk
PulsarTEnvironmentModel
    package: 'Pulsar-Browser'
```

Models that compose this trait gain convenient access to environment-level services.

## The Model Tree

```
PvEnvironmentModel (root)
  │
  ├── PvPackageModel (all packages)
  │     ├── PvPackageTagModel
  │     │     └── class hierarchy (PvTreeNodeModel)
  │     └── PvVirtualPackageTagModel (virtual tags, e.g. "unclassified")
  │
  └── PulsarMultiProjectModel (via newMultiProjectModel)
        ├── PulsarProjectModel (e.g., BaselineOfPulsar)
        └── PulsarVolatileProjectModel (volatile/unknown projects)
```

The tree is built lazily: `children` is called on demand and recomputed on each call (only `PulsarMultiProjectModel` keeps its project models in a slot). Models are created via factory class methods that wire `environmentModel` and `parentModel`.

## Environment and the Updater

`PvEnvironmentModel` receives no announcements itself. System changes are observed at the application level: `PulsarApplication >> registerToSystemEvents` subscribes to system announcements. Editors and panels then react to `PvChangedAnnouncement` through visitors (see chapter 15 for details on the updater system).

## Creating a Model Within an Environment

```smalltalk
"MyModel class >> newEnvironment: parent: entity:"
MyModel newEnvironment: anEnvironmentModel parent: parentModel entity: myEntity
```

This wires the model into the tree. The `environmentModel:` setter stores the back-reference; `parentModel:` stores the parent.

## PulsarSystemNavigation

```smalltalk
PulsarSystemNavigation
    package: 'Pulsar-Browser'
```

A facade for navigating the system from within the browser. Created by the browser and available to actions and tools:

```smalltalk
PulsarBaseBrowser >> systemNavigation
    ^ PulsarSystemNavigation newWindow: self
```

It centralizes navigation operations like browsing a class, opening a method, or inspecting an object — ensuring they happen within the correct browser context.

## Key Classes

| Class | Package | Role |
|---|---|---|
| `PvSystemEnvironment` | Perspective | Low-level Pharo system discovery |
| `PvEnvironmentModel` | Perspective | Root model of the tree |
| `PulsarTEnvironmentModel` | Pulsar-Browser | Trait for environment access |
| `PulsarSystemNavigation` | Pulsar-Browser | Navigation facade for tools |
