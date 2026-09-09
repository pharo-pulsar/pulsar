# 12. How to Add a Non-Central Panel (Tool)

A "non-central panel" is a tool that docks to the **left, right, bottom, or top** of a browser window — not in the center editor area. Examples: the Class Outline, the Editor Stack, the Changes browser, the Repositories view.

## Step-by-Step Recipe

### 1. Create the Model

```smalltalk
PvBaseModel subclass: #MyToolModel
    slots: { }
    classVariables: { }
    package: 'Pulsar-Tool-MyThing'

MyToolModel >> name
    ^ 'My Tool'

MyToolModel >> iconName
    ^ #myTool

MyToolModel >> children
    ^ #()  "no sub-navigation"
```

The model wraps the data your panel will display. If your panel doesn't need a model (it's self-contained), you can skip this step and use `nil` as the model.

### 2. Create the Presenter

```smalltalk
PulsarBaseView subclass: #MyToolView
    slots: { myList. myButton }
    uses: PulsarTControlUpdate
    package: 'Pulsar-Tool-MyThing'

MyToolView class >> defaultPanelPosition
    ^ SpPanelPosition endArea

MyToolView >> initializePresenters
    myList := self newList.
    myButton := self newButton
        label: 'Refresh';
        action: [ self refresh ].
    self layout: (SpBoxLayout newTopToBottom
        add: myButton expand: false;
        add: myList;
        yourself)

MyToolView >> setModel: aModel
    super setModel: aModel.
    self updateList

MyToolView >> updateList
    self updatingWhile: [
        myList items: self model children ]

MyToolView >> refresh
    self scheduleTask: [
        self model refresh.
        self notificationCenter announce: PulsarModelChanged new ]
```

**Key things to get right:**
- Define `defaultPanelPosition` on the class side (`startArea`, `endArea`, `topArea`, `bottomArea` — see Panel Positioning below). The instance-side `panelPosition` delegates to it.
- Compose `PulsarTControlUpdate` and use `updatingWhile:` for model-change handlers
- Views already provide `actions` via `PulsarTActionContainer` (composed by `PulsarBaseView`) — no extra trait needed
- Subscribe to `PulsarModelChanged` and `PulsarThemeChanged` for dynamic updates

### 3. Create the Announcement (Optional)

If you want the panel to be openable programmatically, create a request announcement:

```smalltalk
PulsarRequestToolAnnouncement subclass: #MyToolAnnouncement
    package: 'Pulsar-Tool-MyThing'

MyToolAnnouncement >> toolClass
    ^ MyToolView

MyToolAnnouncement >> isUnique
    ^ true  "prevent duplicates; set to false to allow multiple instances
```

### 4. Register in the Browser (Choose One)

#### Option A: Toggle Button in the View Menu

Add a `<dockActions>` method to the browser:

```smalltalk
PulsarBaseBrowser >> defineViewActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #view with: [ :group |
        group
            priority: 900;
            beDisplayedAsGroup;
            addActionWith: [ :action |
                action
                    name: 'Class Outline';
                    description: 'Open a class outline panel';
                    actionState: [ self hasPresenterClass: PulsarClassOutlineView ];
                    action: [ self doToggleTool: PulsarClassOutlineView fromState: action state ] ] ]
```

Use `actionState:` to show a checkmark when the panel is visible, and `doToggleTool:fromState:` for the toggle behavior.

#### Option B: Announce It Programmatically

From any action or code:

```smalltalk
aContext notificationCenter announce: (MyToolAnnouncement new model: myModel)
```

The browser's `addTool:` handler responds:

```smalltalk
PulsarBaseBrowser >> addTool: ann
    ann isUnique ifTrue: [
        (self findPresenterClass: ann toolClass) ifNotNil: [ :aPresenter |
            aPresenter withPanelWidgetDo: [ :aPanelWidget |
                aPanelWidget raiseAndTakeKeyboardFocus ].
            ^ self ] ].

    self addPresenterClass: ann toolClass model: ann model
```

If `isUnique` is `true` and the panel is already open, it just raises it. Otherwise, a new presenter is instantiated and docked.

### 5. Add to the Baseline

Add your package to `BaselineOfPulsar`:

```smalltalk
BaselineOfPulsar >> baseline: spec
    <baseline>
    spec for: #common do: [
        spec package: 'Pulsar-Tool-MyThing' ]
```

## Panel Positioning

```smalltalk
MyToolView class >> defaultPanelPosition
    ^ SpPanelPosition endArea
```

The instance-side `panelPosition` (on `PulsarBaseView`) answers `self class defaultPanelPosition`.

| Position | Description |
|---|---|
| `SpPanelPosition startArea` | Left sidebar (start of the window, LTR) |
| `SpPanelPosition endArea` | Right sidebar |
| `SpPanelPosition bottomArea` | Bottom panel |
| `SpPanelPosition topArea` | Top panel |
| `SpPanelPosition centerArea` | Center/editor area (use for editors) |

## Saving and Restoring Position

The browser remembers where each panel class was last positioned:

```smalltalk
PulsarBaseBrowser >> addPresenterClass: aClass
    | view position |
    view := self instantiate: aClass.
    position := self class
        savedPositionForViewClass: aClass
        ifAbsent: [ view panelPosition ].
    self addPresenter: view at: position.
    ^ view
```

When the panel is moved by the user, the position is saved:

```smalltalk
aWindow presenter isEditor ifFalse: [
    aWindow whenPanelPositionChangedDo: [ :newPosition |
        aWindow window class
            savePanelPosition: newPosition
            forViewClass: aWindow presenter class ] ]
```

Editors are excluded from position saving (they always stay in the center).

## Being a Good Panel Citizen

1. **Compose `PulsarTControlUpdate`** — use `updatingWhile:` when reacting to model changes to avoid re-entrant update cycles
2. **Subscribe via `PulsarTNotificationCenter`** (already composed by `PulsarBaseView`) — listen to `PulsarThemeChanged` and `PulsarModelChanged` to stay in sync
3. **Override `snapshot`** — return a custom `PulsarPanelSnapshot` subclass to persist your panel's scroll position, selection, and any relevant state (see chapter 8)
4. **Pull data, don't push** — your panel should observe announcements and pull fresh data, rather than expecting others to push updates to it
5. **Clean up on close** — the announcer holds weak subscriptions (GC handles them); override the `windowClosed` hook if your panel needs explicit cleanup

## Minimal Complete Example

```smalltalk
"Model"
PvBaseModel subclass: #CounterModel
    slots: { count }
    package: 'Pulsar-Tool-Counter'

CounterModel >> name
    ^ self count asString

CounterModel >> count
    ^ count ifNil: [ count := 0 ]

CounterModel >> increment
    count := self count + 1


"Presenter"
PulsarBaseView subclass: #CounterView
    slots: { label. button }
    uses: PulsarTControlUpdate
    package: 'Pulsar-Tool-Counter'

CounterView class >> defaultPanelPosition
    ^ SpPanelPosition endArea

CounterView >> initializePresenters
    label := self newLabel label: '0'.
    button := self newButton
        label: 'Increment';
        action: [ self model increment. label label: self model name ].
    self layout: (SpBoxLayout newTopToBottom
        add: label expand: false;
        add: button expand: false;
        yourself)
```

That's it. The panel can be opened from an action, via an announcement, or manually with `browser addPresenterClass: CounterView`.
