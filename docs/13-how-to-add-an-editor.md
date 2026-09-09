# 13. How to Add an Editor

An **editor** in Pulsar is a presenter that opens in the **center** area of the browser when its corresponding model is activated (double-clicked, Enter). Examples: `PulsarClassEditor`, `PulsarMethodEditor`, `PulsarFileEditor`, `PulsarPackageEditor`, `PulsarProjectEditor`.

Unlike non-central panels, editors integrate with the **model activation system** — the browser automatically opens or focuses an editor when its model receives a `PulsarModelActivated` announcement.

> A center view is not necessarily an editor: the playground (`PulsarPlayground`) opens in the center but is a plain `PulsarBaseView`, not a `PulsarEditor` subclass.

## The Editor Lifecycle

```
User clicks model in outline
    │
    ▼
PulsarModelActivated announcement
    │
    ▼
PulsarBaseBrowser >> eventModelActivated:
    │
    ▼
PulsarBaseBrowser >> maybeDockView:withActivation:
    │
    ├── Model hasPulsarEditor? ──► No ──► ignore
    │
    ├── Editor already open? ──► Yes ──► raise and focus it
    │
    └── Editor not open ──► Instantiate, dock in center, focus
```

## Step-by-Step Recipe

### 1. Create the Model

The model declares which editor class to use, and encapsulates the save semantics:

```smalltalk
PvBaseModel subclass: #MyItemModel
    package: 'Pulsar-Tool-MyThing'

MyItemModel >> name

    ^ self entity name

MyItemModel >> contents

    ^ self entity contents

MyItemModel >> pulsarEditorClass

    ^ MyItemEditor

MyItemModel >> updateWith: aString notifying: anInteractionModel

    self entity contents: aString.
    ^ true
```

- `pulsarEditorClass` determines which presenter opens when this model is activated. Its default implementation on `PvBaseModel` answers `self editorClass`, so overriding `editorClass` alone also works, but `pulsarEditorClass` is the Pulsar-level override point.
- `updateWith:notifying:` is the model-side counterpart of the editor's save flow (see step 4). The model — and only the model — talks to the domain entity; the presenter never touches `self model entity` directly.
- `activationAnnouncementClass` (default `PulsarModelActivated`) can be overridden to send extra context to the editor (see step 5).

### 2. Create the Editor Presenter

`PulsarEditor` already provides the editor components and their default layout, so a new editor only implements what makes it specific:

```smalltalk
PulsarEditor subclass: #MyItemEditor
    package: 'Pulsar-Tool-MyThing'

MyItemEditor >> originalContent

    ^ self model contents

MyItemEditor >> updateEditor

    editorPresenter text: self model contents

MyItemEditor >> updatePresenter

    self model ifNil: [ ^ self ].
    super updatePresenter.
    self updatingWhile: [
        self updateEditor.
        self updateSearch ]
```

**What you get for free** (do not recreate it):

- `toolbarPresenter` (`PulsarEditorToolbarPresenter`), `editorPresenter` (a code presenter configured in `initializeEditor` with Smalltalk styling, context menu, line numbers, system navigation) and `searchBarPresenter` (`PulsarSearchBarPresenter`)
- `defaultLayout`: a vertical box with toolbar / editor / search bar
- Dirty tracking, the dirty marker (accept/cancel overlay), save/cancel handling, close protection (steps 4 and 8)
- Snapshot support (step 7)

**Key things to get right:**

- Subclass `PulsarEditor` (not just `PulsarBaseView`)
- Do not override `initializePresenters` to rebuild the editor surface; if you need extra widgets, call `super initializePresenters` and add them to `toolbarPresenter` (e.g. `PulsarMethodEditor` adds its protocol button there)
- Implement `originalContent` (used to compare against the edited text when deciding dirty state) and `updateEditor` (pushed content into `editorPresenter`); `updatePresenter` is called automatically whenever the model is set (`PulsarBaseView >> model:` ends with `self updatePresenter`)
- Wrap programmatic updates in `updatingWhile:` (from `PulsarTControlUpdate`) so they do not mark the editor as dirty

### 3. Wire Model Activation

The browser handles this automatically. When a `PulsarModelActivated` is announced with your model, the browser checks `model hasPulsarEditor`, gets the editor class, instantiates it, and docks it in the center:

```smalltalk
PulsarBaseBrowser >> maybeDockView: aViewModel withActivation: anActivation
    "if the entity has an editor associated:
    	if the entity is not already there, open it.
    	if the entity is already opened,
    		if it can have multiple views: open it.
    		if it is single view: select it
     otherwise ignore it"
    | editorPresenter |

    aViewModel hasPulsarEditor ifFalse: [ ^ self ].

    (self findEditorContaining: aViewModel)
        ifNotNil: [ :panelPresenter |
            panelPresenter raiseAndTakeKeyboardFocus.
            editorPresenter := panelPresenter presenter ]
        ifNil: [
            editorPresenter := self
                instantiate: aViewModel pulsarEditorClass
                on: aViewModel.
            self
                addPresenter: editorPresenter
                at: (anActivation hasDesiredPosition
                    ifTrue: [ anActivation desiredPosition ]
                    ifFalse: [ editorPresenter panelPosition ]).
            self viewDocked: editorPresenter ].

    editorPresenter activateWith: anActivation
```

### 4. Handle User Modifications (Dirty State)

Dirty tracking is built into `PulsarEditor` — you do not need to implement it:

1. `connectPresenters` subscribes `editorPresenter` to `whenTextChangedDo:`, which sends `textChangedFrom:to:`
2. `textChangedFrom:to:` compares the new text against `originalContent` and sends `markDirty` / `unmarkDirty` (no-op while `updatingWhile:` is active)
3. When dirty, an overlay with Accept/Cancel buttons appears (`newDirtyMarkerPresenter`); Accept sends `doSubmit: editorPresenter text`, Cancel sends `doReset`
4. The save flow goes through the model: `doSubmit:` → `updateModel:` → `self model updateWith: aString notifying: editorPresenter interactionModel`; on success the editor unmarks dirty and announces `PulsarModelChanged`

> `hasUnacceptedEdits` is a Morphic/Calypso hook (implemented by `Model`, `RubScrolledTextMorph`, `SystemWindow`, ...), not part of Pulsar. Pulsar editors use `isDirty` / `markDirty` / `unmarkDirty` instead.

### 5. Activation with Context

The activation announcement can carry extra information:

```smalltalk
MyItemModel >> activationAnnouncementClass

    ^ MyItemActivated

PulsarModelActivated subclass: #MyItemActivated
    slots: { #cursorPosition }
    package: 'Pulsar-Tool-MyThing'

MyItemEditor >> activateWith: anActivation

    super activateWith: anActivation.
    anActivation cursorPosition ifNotNil: [ :pos |
        editorPresenter cursorPositionIndex: pos ]
```

`activateWith:` is an empty hook on `PulsarBaseView`; the entity that triggered the activation (e.g., a method reference in the outline) can announce an activation carrying context such as cursor position.

### 6. Editor Toolbar

Editors get a toolbar from `PulsarEditor`. The toolbar is populated via `<dockActions>` pragmas; editor-specific content actions are added to the `#editorActions` group, which `updateContentActions` installs in the toolbar:

```smalltalk
MyItemEditor class >> defineActionsOn: aBuilder
    <dockActions>

    aBuilder addGroup: #editorActions with: [ :group | group
        priority: 1;
        name: 'Editor';
        beDisplayedAsGroup;
        addActionWith: [ :action | action
            name: 'Format';
            description: 'Format the content';
            action: [ :aContext | aContext doFormatContent ] ] ]
```

- The action block receives a `PulsarActionContext` (`aContext`); the receiver is the editor, so implement `doFormatContent` there
- `PulsarEditor` already contributes the `#navigation` group ("Show hierarchy", "Show senders") via `defineNavigationActionsOn:`
- Actions can be declared on the instance side or the class side; `PulsarActionCollector` scans both

### 7. Snapshot Support

`PulsarEditor >> snapshot` already returns `PulsarEditorSnapshot on: self`, which captures the cursor position, the dirty flag, the edited text (only when dirty) and a timestamp. No override is needed unless the editor has extra state: then subclass `PulsarEditorSnapshot` and override `snapshot:` / `restoreTo:`.

### 8. Editor Closing

There is no `deactivate` message. The end of an editor's life is driven by the window:

- `initializeWindow:` registers `whenClosedDo: [ self notifyEditorClosed ]`
- While dirty, `windowWillClose:` sends `denyClose`, so the window refuses to close
- The panel widget asks to save or discard; `saveContent` (used by its save button) sends `doSubmit:` and answers whether saving succeeded, which validates the close
- The model fires `PulsarModelDeactivated`, and the browser removes the editor panel

## Editor vs. Non-Central Panel

| Aspect | Non-Central Panel | Editor |
|---|---|---|
| Base class | `PulsarBaseView` | `PulsarEditor` (extends `PulsarBaseView`) |
| Position | `left`, `right`, `bottom`, `top` | `center` (required) |
| Opening | Action/ActionAnnouncement request | Model activation |
| Managing multiple views | Announcements | Model-activate/deactivate events |
| Dirty tracking | Rarely needed | Built-in |
| Toolbar | Optional | Included |
| Snapshot | Optional | Included |
| Position persistence | Saved per class | Always center |

## Center Views That Are Also Tools

Some center views are not editors but can still be requested as tools (e.g., the playground, `PulsarPlayground`, a plain `PulsarBaseView`). The browser handles this via `addTool:`, which checks `isUnique` before creating duplicates.

## Minimal Example

A notes editor: the model owns the save logic, the editor only pushes content in and out:

```smalltalk
"Model"
PvBaseModel subclass: #NoteModel
    package: 'Pulsar-Tool-Notes'

NoteModel >> name

    ^ self entity title

NoteModel >> contents

    ^ self entity body

NoteModel >> pulsarEditorClass

    ^ NoteEditor

NoteModel >> updateWith: aString notifying: anInteractionModel

    self entity body: aString.
    ^ true

"Editor"
PulsarEditor subclass: #NoteEditor
    package: 'Pulsar-Tool-Notes'

NoteEditor >> originalContent

    ^ self model contents

NoteEditor >> updateEditor

    editorPresenter text: self model contents
```

That is the entire editor: no extra slots, no `initializePresenters` or `defaultLayout` override, no `setModel:`, no manual dirty wiring. `PulsarEditor` provides the toolbar, the text editor, the search bar, the layout and the dirty machinery; `updatePresenter` is inherited and calls `updateEditor`.

The save flow is: the user edits → `textChangedFrom:to:` marks the editor dirty (the accept/cancel overlay appears) → Accept → `doSubmit:` → `updateModel:` → `NoteModel >> updateWith:notifying:` updates the entity → the editor unmarks dirty and announces `PulsarModelChanged`.
