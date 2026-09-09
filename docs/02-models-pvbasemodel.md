# 2. Models — PvBaseModel and the Model Layer

Every piece of domain information visible in Pulsar is wrapped in a subclass of `PvBaseModel`. This chapter explains how models work, what they provide, and how to create your own.

## Core Instance Variables

`PvBaseModel` defines three fundamental slots:

| Slot | Purpose |
|---|---|
| `entity` | The wrapped domain object (an `RPackage`, a `Class`, an `IceRepository`, etc.) |
| `environmentModel` | Back-pointer to the root `PvEnvironmentModel` |
| `parentModel` | The model's parent in the tree (nil for the root) |

## Identity and Equality

Two models are **equal** if they have the same class and wrap the **same entity**:

```smalltalk
PvBaseModel >> =
    ^ self species = other species
        and: [ self entity = other entity ]
```

The `hash` is the XOR of the species hash and the entity hash. This means two different model instances wrapping the same entity are considered the same model, which is important for finding existing editors and avoiding duplicates.

## Construction

Models are created through class-side factory methods, not `new` directly:

```smalltalk
"Create a model that wraps an entity within an environment"
PvMyModel newEnvironment: anEnvironmentModel entity: myEntity

"Create a model with a parent (for tree position)"
PvMyModel newEnvironment: anEnvironmentModel parent: parentModel entity: myEntity

"Create a root-level model (no entity)"
PvMyModel newEnvironment: anEnvironmentModel
```

The `environmentModel:` setter assigns the back-reference; `entity:` assigns the domain object.

## Children and the Model Tree

Models form a tree. The `children` method returns sub-models for navigation:

```smalltalk
PvBaseModel >> children
    ^ #()  "default: no children"
```

Subclasses override this. For example, a package model returns tag models (`PvPackageTagModel`, plus virtual tags); a tag model returns the class hierarchy (built by `PvClassHierarchyBuilder`); a class model has no children. The browser uses this tree for its outline view and for spotter search.

## Actions

Every model can contribute UI actions. The `actions` method lazily collects them:

```smalltalk
PvBaseModel >> actions
    ^ actions ifNil: [ actions := PulsarActionCollector collectFor: self ]
```

`PulsarActionCollector` scans both the instance side and class side of the model's class for methods tagged with the `<dockActions>` pragma. These methods receive an `SpActionGroup` builder and populate it with commands.

To provide actions, override `defineActionsOn:` on the model (following the `defineXxxActionsOn:` convention, e.g. `defineRefactorActionsOn:`, `defineDecorationActionsOn:`):

```smalltalk
MyModel >> defineActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #myGroup with: [ :group |
        group priority: 500.
        group addActionWith: [ :action |
            action
                name: 'Do Something';
                description: 'Perform an action';
                action: [ self doSomething ] ] ]
```

The action block runs with the declaring model as context (`self`). It may also take an argument — `action: [ :aContext | aContext doSomething ]` — when the action must execute in a context different from the declaring object (e.g. UI interactions).

## Presentation Metadata

Models provide metadata that the UI uses to render them:

| Method | Returns | Purpose |
|---|---|---|
| `name` | String | Unique identifier within the tree (subclass responsibility) |
| `fullName` | String | Full display name (defaults to `name`) |
| `shortName` | String | Abbreviated name for tight layouts |
| `title` | String | Window/tab title (defaults to `fullName`) |
| `pageTitle` | String | Breadcrumb page title (defaults to `shortName`) |
| `iconName` | Symbol or nil | Icon identifier for the model |

## Editor Association

A model declares which presenter class should be used as its editor:

```smalltalk
PvBaseModel >> pulsarEditorClass
    ^ self editorClass  "defaults to editorClass"
```

Override `editorClass` (or `pulsarEditorClass` for more control) to return a presenter class. When the model is **activated** (e.g., double-clicked in the outline), the browser's `maybeDockView:withActivation:` method instantiates this presenter and docks it in the center area.

```smalltalk
PvBaseModel >> hasEditor
    ^ self editorClass notNil

PvBaseModel >> hasPulsarEditor
    ^ self pulsarEditorClass isNotNil
```

This duplication is because of historical reasons, and will disappear in the future.

## Selection and Activation

Models communicate their UI state through two announcement classes:

```smalltalk
PvBaseModel >> selectionAnnouncementClass
    ^ PulsarModelSelected      "fired when the model is highlighted/clicked"

PvBaseModel >> activationAnnouncementClass
    ^ PulsarModelActivated     "fired when the model is opened (double-click, Enter)"
```

These are used by the browser to react to user navigation. A model can override these to provide custom announcement classes with extra context.

## Lifecycle Hooks

| Method | When called |
|---|---|
| `canBeRemoved` | Before deleting the model (overridable guard) |
| `canBeRenamed` | Before renaming the model (overridable guard) |
| `prepareForSnapshot` | Before the model is serialized into a snapshot |
| `realModel` | Returns `self` by default; overridden by proxy/decorator models |

## Convenience Queries

| Method | Purpose |
|---|---|
| `isPackage`, `isPackageTag`, `isPackageOrTag` | Type checks for package models |
| `isClassModel`, `isMethodModel` | Type checks for code models |
| `isProject` | Type check for project models |
| `isContextModel` | Type check for debugger context models |
| `isOutlineClassEntity` | Whether this model appears in the class outline |
| `isManagedAndModified` | Whether this model represents modified Iceberg-managed code |

## Creating a Custom Model

```smalltalk
PvBaseModel subclass: #MyToolModel
    slots: { }
    classVariables: { }
    package: 'Pulsar-Tool-MyThing'

MyToolModel >> name
    ^ self entity name

MyToolModel >> children
    ^ self entity subItems collect: [ :each |
        MyToolModel newEnvironment: self environmentModel parent: self entity: each ]

MyToolModel >> iconName
    ^ #myTool

MyToolModel >> pulsarEditorClass
    ^ MyToolEditor
```

The model is a pure adapter — it should not hold UI state. Any state that needs to survive image restarts should be part of the presenter, not the model (and handled through snapshots — see chapter 8).
