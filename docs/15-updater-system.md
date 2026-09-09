# 15. Updating the UI

This chapter explains how Pulsar keeps its user interface in sync with the system: what happens when a method is modified, a class is removed, or a package is loaded, and how each presenter decides whether it needs to refresh itself.

> **Important:** the class `PulsarUpdater` is **not** the mechanism that refreshes the UI. It is the *self-updater* used by the `pulsar update` CLI command. Both are covered here because they are easy to confuse.

## The Two "Updaters"

| Mechanism | What it does |
|---|---|
| `PulsarUpdater` | Downloads and evaluates the update script (`Load.st`) for the `pulsar update` command. Has nothing to do with the UI. |
| System announcements | The real UI-sync flow: the browser listens to `SystemAnnouncement` subclasses and re-broadcasts them to all presenters. |

## PulsarUpdater (Self-Update)

`PulsarUpdater` [Pulsar-Browser, tag Utilities] downloads the update script from the Pulsar repository and evaluates it:

```smalltalk
PulsarUpdater >> downloadUpdateFile
    ^ ZnClient new
        url: 'https://forge.smallworks.eu/pharo/Pulsar/raw/branch/main/.ci/scripts/Load.st';
        numberOfRetries: 5;
        timeout: 100;
        loggingOn;
        get;
        contents

PulsarUpdater >> updateScript
    ^ self downloadUpdateFile
        in: [ :contents |
            (contents beginsWith: 'MetaMetacello load:')
                ifFalse: [ self error: 'Bad update script format.' ].
            contents copyReplaceAll: 'MetaMetacello load:' with: 'MetaMetacello update:' ]

PulsarUpdater >> update
    OpalCompiler evaluate: self updateScript.
    [ Smalltalk snapshot: true andQuit: false ] fork.
    10 milliSeconds wait

PulsarUpdater class >> update
    ^ self new update
```

`executeUpdate` in `PulsarCLIApplication` calls `PulsarUpdater update` when the user runs `pulsar update` (see chapter 5).

## How the UI Stays in Sync

The UI is kept in sync through the **announcement flow**, not through a central updater:

1. Pharo's tools announce `SystemAnnouncement` subclasses when code changes (e.g. `MethodModified`, `MethodRemoved`, `ClassAdded`).
2. The browser (`PulsarBaseBrowser`) subscribes to these announcements and re-broadcasts them to every open window's presenter:

```smalltalk
PulsarBaseBrowser >> registerToSystemEvents
    self announcer
        when: JobStart send: #eventJobStart: to: self;
        when: JobEnd send: #eventJobEnd: to: self;
        when: SystemAnnouncement, MetacelloExecutionAnnouncement
            send: #resendAnnouncement: to: self

PulsarBaseBrowser >> resendAnnouncement: anAnnouncement
    self presentersDo: [ :aWindowPresenter |
        aWindowPresenter presenter announce: anAnnouncement ]
```

3. Each view subscribes to the announcements it cares about in `registerToSystemEvents`. `PulsarBaseView` provides an empty hook:

```smalltalk
PulsarBaseView >> registerToSystemEvents
    "subclasses can fill this"
```

## Example: PulsarMethodEditor

The method editor is the canonical example of an update-aware presenter:

```smalltalk
PulsarMethodEditor >> registerToSystemEvents
    super registerToSystemEvents.
    self announcer
        when: MethodRecategorized send: #eventMethodRecategorized: to: self;
        when: MethodRepackaged send: #eventMethodRepackaged: to: self;
        when: MethodModified send: #eventMethodModified: to: self;
        when: MethodRemoved send: #eventMethodRemoved: to: self
```

Each handler checks whether the change affects *its* model, and guards against re-entrant updates:

```smalltalk
PulsarMethodEditor >> eventMethodModified: anAnnouncement
    (self model entity = anAnnouncement method
        or: [ self model entity = anAnnouncement oldMethod ])
        ifFalse: [ ^ self ].
    "Is me who is updating, get out"
    self isUpdating ifTrue: [ ^ self ].
    self isDirty ifTrue: [ ^ self ].
    methodModified := anAnnouncement method.
    "update model"
    self model entity: methodModified.
    "update presenter"
    self updatePresenter
```

The guard pattern:

- **Identity check** — the announcement is ignored if it does not concern this editor's entity.
- **`isUpdating`** — prevents re-entrant updates (see the `updatingWhile:` guard below).
- **`isDirty`** — an editor with unaccepted changes is not refreshed (the user's edits win).

## Model-Level Announcements

When an editor accepts changes (`doSubmit:`), it announces a `PulsarModelChanged` so that *other* presenters showing the same model can refresh:

```smalltalk
PulsarModelChanged
    superclass: PulsarAnnouncement
    slots: { oldEntity }
    package: 'Pulsar-Browser'
```

The announcement carries the new model (`value`, inherited from `PulsarAnnouncement`) and the replaced entity (`oldEntity`). Presenters subscribe through their notification center and compare the announcement's value against their own model.

## The updatingWhile: Guard

`PulsarTControlUpdate` provides a re-entrancy guard used by editors and views when they update themselves in response to events:

```smalltalk
PulsarTControlUpdate >> updatingWhile: aBlock
    | oldUpdating |
    oldUpdating := self isUpdating.
    updating := true.
    ^ aBlock ensure: [ updating := oldUpdating ]

PulsarTControlUpdate >> isUpdating
    ^ updating ifNil: [ updating := false ]
```

Wrap any self-modification performed during an event handler in `updatingWhile:` so that the editor's own changes do not trigger another update cycle.

## Model Visitors

Visitors are the other side of the update coin: instead of reacting to announcements, they walk the model tree and act on each model.

### PulsarModelVisitor

`PulsarModelVisitor` [Pulsar-Browser] provides the double-dispatch scaffolding:

```smalltalk
PulsarModelVisitor
    slots: { owner }
    package: 'Pulsar-Browser'

PulsarModelVisitor >> visit: aModel
    ^ aModel accept: self
```

It defines empty hooks for each model kind: `visitModel:`, `visitClassModel:`, `visitMethodModel:`, `visitPackageModel:`, `visitPackageTagModel:`, and `visitProjectModel:`. Subclasses implement the ones they need and traverse children themselves. Real subclasses include `PulsarCritiquesModel` and `PulsarFlagsModel` (collecting models), and `PulsarProjectRenameModel` / `PulsarProjectRemoveModel` (renaming/removing classes across a project, see chapter 7).

### PulsarEditorVisitor and PulsarEditorUpdateVisitor

`PulsarEditorVisitor` [Pulsar-Browser, tag View-Editor] is the presenter counterpart:

```smalltalk
PulsarEditorVisitor >> visit: aPresenter
    ^ aPresenter acceptVisitor: self
```

It provides empty hooks per editor kind (`visitClassEditor:`, `visitMethodEditor:`, `visitPackageEditor:`, `visitProjectEditor:`, `visitContextEditor:`), all funneling through `visitEditor:` into `visitPresenter:`.

`PulsarEditorUpdateVisitor` is its only Pulsar-internal subclass:

```smalltalk
PulsarEditorUpdateVisitor >> visitPanelWindowPresenter: aPanelWindowPresenter
    self owner updatePanelWindowTitle

PulsarEditorUpdateVisitor >> visitPopoverPresenter: aPopoverPresenter
    "nothing to do"
```

Its single use is updating the window title when an editor changes:

```smalltalk
PulsarEditor >> updateTitle
    self shouldUpdateTitle ifFalse: [ ^ self ].
    self nearWindowLike ifNotNil: [ :aWindow |
        (PulsarEditorUpdateVisitor on: self) visit: aWindow ]
```

## PvChangedAnnouncement (Perspective)

`PvChangedAnnouncement` [Perspective, tag Announcement] is an announcement defined by the Perspective layer:

```smalltalk
PvChangedAnnouncement >> performSelector
    ^ #entityChanged:
```

It is used by `PvPerspectiveBrowser >> subscribeToAnnouncements` and has nothing to do with `PulsarModelChanged` — the two announcements live in different layers (Perspective vs Pulsar-Browser).

## Updater-Related Classes

| Class | Role |
|---|---|
| `PulsarUpdater` | Self-updater: downloads and evaluates the update script for `pulsar update` |
| `PulsarBaseBrowser` | Subscribes to system announcements and re-broadcasts them (`resendAnnouncement:`) |
| `PulsarBaseView` | Provides the `registerToSystemEvents` hook (empty) |
| `PulsarModelVisitor` | Double-dispatch scaffold for model-tree walkers |
| `PulsarEditorVisitor` | Double-dispatch scaffold for editor presenters |
| `PulsarEditorUpdateVisitor` | Updates the window title (`updatePanelWindowTitle`) |
| `PulsarModelChanged` | Announced by editors after accepting changes (`value` + `oldEntity`) |
| `PvChangedAnnouncement` | Perspective-layer generic change announcement (`#entityChanged:`) |
| `PulsarTControlUpdate` | Re-entrancy guard (`updatingWhile:` / `isUpdating`) |

## Writing an Update-Aware Presenter

```smalltalk
PulsarBaseView subclass: #MyStatusView
    slots: { statusPresenter }
    uses: PulsarTControlUpdate
    package: 'Pulsar-Tool-MyThing'

MyStatusView >> registerToSystemEvents
    self announcer
        when: MyEntityModified send: #eventEntityModified: to: self

MyStatusView >> eventEntityModified: anAnnouncement
    (self model entity = anAnnouncement entity) ifFalse: [ ^ self ].
    self isUpdating ifTrue: [ ^ self ].
    self updatingWhile: [ self updateStatus ]

MyStatusView >> updateStatus
    statusPresenter label: self model entity status
```

The same recipe applies to any view: subscribe in `registerToSystemEvents`, ignore announcements that do not concern your model, and wrap self-modifications in `updatingWhile:`.
