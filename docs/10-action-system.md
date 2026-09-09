# 10. Action System

Pulsar's action system is how commands, toolbar buttons, and context menus are defined and dispatched. Actions are collected from **pragma-tagged methods** and executed through a **context object** that gives them access to scheduling, notifications, and the application.

## Overview

```
Model or Presenter
    │
    │ defines methods tagged with <dockActions>
    ▼
PulsarActionCollector
    │ scans pragmas, builds SpActionGroups
    ▼
SpActionGroup (sorted by priority)
    │
    ▼
SpAction (with context: PulsarActionContext)
    │
    │ user clicks
    ▼
Action executes via PulsarActionContext
    │
    ├── scheduleTask: / scheduleJob:
    ├── notificationCenter announce:
    ├── application
    └── window
```

## PulsarActionCollector

```smalltalk
PulsarActionCollector
    slots: { model. context }
    package: 'Pulsar-Browser'
```

The collector scans for `<dockActions>` pragmas and assembles them into `SpActionGroup`:

```smalltalk
PulsarActionCollector >> collect
    | container |
    container := SpActionGroup new.
    self register: self model in: container.

    container entries: (container entries sorted: #priority ascending, #name ascending).
    container allCommands do: [ :each | each context: self context ].

    ^ container
```

### Pragma Scanning

```smalltalk
PulsarActionCollector >> register: aModel in: container
    "instance side"
    (Pragma allNamed: #dockActions from: aModel class to: SpPresenter)
        do: [ :eachPragma |
            aModel perform: eachPragma methodSelector with: container ].
    "class side"
    (Pragma allNamed: #dockActions from: aModel class class to: SpPresenter)
        do: [ :eachPragma |
            aModel class perform: eachPragma methodSelector with: container ]
```

The collector scans from the model's class **up to `SpPresenter`** (the base presenter class), finding all `<dockActions>` methods. Both instance-side and class-side methods are included. This means a model's actions can be defined on the model itself, on its class, or on any superclass in the hierarchy.

When no explicit context is given, the context defaults to the model itself:

```smalltalk
PulsarActionCollector >> context
    ^ context ifNil: [ self model ]
```

That is why `PvBaseModel >> actions` (below) works: the actions execute in the context of the model that declared them.

## Defining Actions

Actions are defined by methods tagged with `<dockActions>`. The method receives an `SpActionGroup` builder:

```smalltalk
MyModel >> defineMyActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #myGroup with: [ :group |
        group
            beDisplayedAsGroup;
            priority: 500;
            addActionWith: [ :action |
                action
                    name: 'Do Thing';
                    description: 'Performs the thing';
                    iconName: #myIcon;
                    actionState: [ self isReady ];
                    action: [ self doThing ] ] ]
```

### Action Properties

| Property | Purpose |
|---|---|
| `name:` | Display label |
| `description:` | Tooltip |
| `iconName:` | Icon identifier |
| `action:` | Block executed when clicked |
| `actionState:` | Boolean block for toggle-state actions (checked/unchecked) |
| `actionEnabled:` | Boolean block controlling whether the action is clickable |
| `actionVisible:` | Boolean block controlling whether the action is shown |

### Group Properties

| Property | Purpose |
|---|---|
| `priority:` | Sort order (lower = earlier) |
| `beDisplayedAsGroup` | Render as a separator-delimited group |
| `enabledWhenNone:` | Enabled state when no action is active |

## PulsarPragmaCollector

A lower-level utility for scanning pragmas:

```smalltalk
PulsarPragmaCollector
    package: 'Pulsar-Browser'
```

```smalltalk
PulsarPragmaCollector >> collectPragma: aSelector in: anObject withArguments: aCollection
    ^ { anObject. anObject class }
        flatCollect: [ :each |
            (Pragma allNamed: aSelector in: each class)
                collect: [ :eachPragma |
                    aCollection
                        ifNotNil: [ eachPragma methodSelector
                            performOn: each
                            withEnoughArguments: aCollection ]
                        ifNil: [ each perform: eachPragma methodSelector ] ] ]
```

The class also provides `traversePragma:in:withArguments:` (a `do:`-style variant) and class-side entry points (`PulsarPragmaCollector collectPragma:in:`, etc.).

Used directly when the collector's group-building is not needed — for example, `PulsarApplication` scans for `<iconProvider>` pragmas to register the icon providers (see chapter 19).

## PulsarActionContext

```smalltalk
PulsarActionContext
    slots: { owner }
    package: 'Pulsar-Browser'
```

A **facade** that wraps a presenter and gives actions access to infrastructure:

```smalltalk
PulsarActionContext >> on: aPresenter
    ^ self new owner: aPresenter; yourself

PulsarActionContext >> application
    ^ self owner application

PulsarActionContext >> window
    ^ self owner isWindow
        ifTrue: [ self owner ]
        ifFalse: [ self owner window ]

PulsarActionContext >> notificationCenter
    ^ self window notificationCenter

PulsarActionContext >> scheduleTask: aBlock
    self window scheduleTask: aBlock

PulsarActionContext >> scheduleJob: aBlock
    self window scheduleJob: aBlock
```

**Rule: actions are context-driven, not view-driven.** An action receives the context, not a direct reference to the view. Through the context, it can schedule background work, announce events, and access the application.

### When to Use Each

```smalltalk
"For simple synchronous work:"
MyModel >> doRename
    self requestNewName ifNotNil: [ :newName |
        self entity rename: newName ]

"For background work that doesn't need feedback:"
MyModel >> doRefresh: aContext
    aContext scheduleTask: [
        self entity refresh ]

"For user-initiated work with a spinner:"
MyModel >> doLoadDependencies: aContext
    aContext scheduleJob: [
        self entity loadDependencies.
        aContext notificationCenter announce: PulsarModelChanged new ]
```

## PulsarActionContextVisitor

A `CmVisitor` subclass that sets a context on an action group and all its children. It is used when actions collected from different places must all execute in the context of a specific presenter:

```smalltalk
PulsarActionContextVisitor
    slots: { context }
    superclass: #CmVisitor
    package: 'Pulsar-Browser'
```

Its single real use in Pulsar is `PulsarEditor >> updateContentActions`, which attaches the editor as context to its toolbar content actions:

```smalltalk
contentActions := PulsarActionContextVisitor new
    context: self;
    visit: self collectContentActions.
toolbarPresenter contentActions: contentActions
```

## Action Collection from Models

Models lazily collect their actions:

```smalltalk
PvBaseModel >> actions
    ^ actions ifNil: [ actions := PulsarActionCollector collectFor: self ]
```

When a context is known at the time of collection (e.g., for context menus):

```smalltalk
PvBaseModel >> actionsWithContext: aContext
    ^ PulsarActionCollector new
        model: self;
        context: aContext;
        collect
```

## Global Actions (Browser-Level)

The browser also collects its own actions for the toolbar and menu bar. The accessor is provided by the `PulsarTGlobalActionContainer` trait, which `PulsarBaseBrowser` composes:

```smalltalk
PulsarTGlobalActionContainer >> globalActions
    ^ globalActions ifNil: [ globalActions := PulsarActionCollector collectFor: self ]
```

These are defined via `<dockActions>` on the browser class or its superclasses:

```smalltalk
PulsarBaseBrowser >> defineViewActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #view with: [ :group |
        group priority: 900; beDisplayedAsGroup.
        group addActionWith: [ :action |
            action name: 'Class Outline';
                description: 'Show or hide the class outline panel';
                actionState: [ self hasPresenterClass: PulsarClassOutlineView ];
                action: [ self doToggleTool: PulsarClassOutlineView fromState: action state ] ].
        group addActionWith: [ :action |
            action name: 'Editor Stack';
                description: 'Show or hide the editor stack panel';
                actionState: [ self hasPresenterClass: PulsarStackView ];
                action: [ self doToggleTool: PulsarStackView fromState: action state ] ] ]
```

`PulsarBaseBrowser` also defines `defineExtraActionsOn:` (group `#extra`, priority 890) with the "Playground" action, which announces a `PulsarRequestNewPlayground`.

## Refactoring Actions

For context-sensitive refactoring operations, Pulsar uses specialized action contexts:

| Context Class | For |
|---|---|
| `PulsarRefactorActionContext` | Generic refactoring context |
| `PulsarRefactorClassContext` | Class-level refactorings |
| `PulsarRefactorMethodContext` | Method-level refactorings |
| `PulsarRefactorPackageContext` | Package-level refactorings |
| `PulsarRefactorSlotContext` | Slot-level refactorings |

These are created when the user right-clicks on a specific model type, giving the action access to type-specific operations.

## Adding an Action

```smalltalk
MyModel >> defineMyActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #tools with: [ :group |
        group priority: 700.
        group addActionWith: [ :action |
            action
                name: 'My Tool';
                description: 'Open the my-tool panel';
                action: [ :aContext |
                    aContext notificationCenter
                        announce: (MyToolAnnouncement on: self) ] ] ]
```

The action is automatically discovered, sorted by priority, and rendered in the UI. The `aContext` parameter (an `PulsarActionContext`) is injected by the action collector.
