# 18. Refactoring Context

Pulsar provides typed **refactoring action contexts** that give refactoring operations access to the right level of model specificity — class, method, package, or slot.

## The Refactoring Context Hierarchy

```
PulsarActionContext                          — generic context (window, scheduling, notifications)
  └── PulsarRefactorActionContext            — generic refactoring context
        ├── PulsarRefactorClassContext       — class-level refactorings
        ├── PulsarRefactorMethodContext      — method-level refactorings
        ├── PulsarRefactorPackageContext     — package-level refactorings
        └── PulsarRefactorSlotContext        — slot-level refactorings
```

## PulsarActionContext (Recap)

```smalltalk
PulsarActionContext
    slots: { owner }
    package: 'Pulsar-Browser'
```

Provides:
- `application` — the PulsarApplication singleton
- `window` — the owning browser window
- `notificationCenter` — for announcing events
- `scheduleTask:` / `scheduleJob:` — background work dispatching

## PulsarRefactorActionContext

```smalltalk
PulsarRefactorActionContext
    superclass: PulsarActionContext
    package: 'Pulsar-Browser'
```

A **marker subclass** of `PulsarActionContext`: it defines no additional slots or methods. Its purpose is to give refactoring actions a distinguishable context type. Created when the user opens a context menu on a model entity that supports refactoring.

## Typed Contexts

The typed contexts are also marker-like: they carry no state. Their value is the set of `do*` operations they offer, each receiving the model as an argument and running a refactoring2 driver.

### PulsarRefactorClassContext

```smalltalk
PulsarRefactorClassContext
    superclass: PulsarRefactorActionContext
    package: 'Pulsar-Browser'
```

Operations:

- `doRenameClass:`
- `doRemoveClass:`
- `doDuplicateClass:`
- `doInsertSubclass:`
- `doInsertSuperclass:`

### PulsarRefactorMethodContext

```smalltalk
PulsarRefactorMethodContext
    superclass: PulsarRefactorActionContext
    package: 'Pulsar-Browser'
```

Operations:

- `doRenameMethod:`
- `doPullUpMethod:`
- `doPushDownMethod:`
- `doPushDownInSomeClassesMethod:`

### PulsarRefactorPackageContext

```smalltalk
PulsarRefactorPackageContext
    superclass: PulsarRefactorActionContext
    package: 'Pulsar-Browser'
```

Operations:

- `doRenamePackage:`
- `doRenamePackageTag:`

### PulsarRefactorSlotContext

```smalltalk
PulsarRefactorSlotContext
    superclass: PulsarRefactorActionContext
    package: 'Pulsar-Browser'
```

Operations:

- `doRenameVariable:`
- `doGenerateVariableAccessors:`
- `doPullUpVariable:`
- `doPushDownVariable:`

Each `do*` receives the corresponding model. For example:

```smalltalk
PulsarRefactorClassContext >> doRenameClass: aClassModel
    self scheduleTask: [ (ReRenameClassDriver
        newApplication: self owner application)
        oldName: aClassModel name asSymbol;
        model: RBBrowserEnvironment new;
        scopes: { RBBrowserEnvironment new };
        runRefactoring ]
```

## How Contexts Are Created

Context-menu builders in views and editors ask the selected model for its refactoring actions:

```smalltalk
PvBaseModel >> actionsWithContextOn: aContextPresenter
    "These are refactors associated to the model objects.
     Not all of them have, in those cases (as default)
     we answer an empty group."
    ^ SpActionGroup new
```

Subclasses override this to return type-specific actions, wrapping them with the matching typed context. For example, a class model returns its `#refactors` action group with a `PulsarRefactorClassContext`:

```smalltalk
PvClassModel >> actionsWithContextOn: aContextPresenter
    ^ (self actions actionsFor: #refactors)
        copyWithContext: (PulsarRefactorClassContext on: aContextPresenter)
```

Callers include `PulsarClassOutlineSideView >> refactorActions` (the class-outline context menu), `PulsarClassEditor >> updateContentActions`, `PulsarMethodEditor >> updateContentActions`, and the repositories views.

## Defining a Refactoring Action

Refactoring actions themselves are defined with `<dockActions>` in a `defineRefactorActionsOn:` method (group `#refactors`) on the model class, and receive the typed context:

```smalltalk
PvClassModel >> defineRefactorActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #refactors with: [ :group |
        group
            name: 'Refactors';
            beDisplayedAsGroup;
            addActionWith: [ :action |
                action
                    name: 'Rename {1}' format: { self name };
                    description: 'Rename class';
                    action: [ :aContext | aContext doRenameClass: self ] ] ]
```

The action block executes with the typed context (`aContext` is a `PulsarRefactorClassContext` above), so the operation runs through the right driver.

## Summary of Context Selection

| Model Type | Refactoring Context |
|---|---|
| Package model | `PulsarRefactorPackageContext` |
| Class model | `PulsarRefactorClassContext` |
| Method model | `PulsarRefactorMethodContext` |
| Slot model | `PulsarRefactorSlotContext` |
| Generic model | `PulsarRefactorActionContext` |
| Any model (UI action) | `PulsarActionContext` |
