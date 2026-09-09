# 14. Request Tool Announcement (`PulsarRequestToolAnnouncement`)

`PulsarRequestToolAnnouncement` is the standard mechanism for **programmatically opening a tool panel** from anywhere in the system. It decouples the code that wants to open a tool from the browser that hosts it.

## How It Works

```
Any code anywhere
    │
    │ announces PulsarRequestToolAnnouncement subclass
    ▼
Notification Center
    │
    ▼
PulsarBaseBrowser >> registerToEvents
    when: PulsarRequestToolAnnouncement send: #addTool: to: self
    │
    ▼
PulsarBaseBrowser >> addTool:
    │
    ├── isUnique and already open? ──► raise existing panel
    └── not open ──► instantiate and dock
```

The announcer and receiver don't need to know about each other. The announcement carries the model (data) and the tool class to instantiate.

## Base Class

```smalltalk
Announcement subclass: #PulsarRequestToolAnnouncement
    slots: { model }
    package: 'Pulsar-Browser'

PulsarRequestToolAnnouncement >> toolClass
    self subclassResponsibility

PulsarRequestToolAnnouncement >> isUnique
    ^ false  "override to true if only one instance allowed"
```

## Creating a Request Announcement

Subclass `PulsarRequestToolAnnouncement` and override `toolClass`:

```smalltalk
PulsarRequestToolAnnouncement subclass: #MyToolAnnouncement
    package: 'Pulsar-Tool-MyThing'

MyToolAnnouncement >> toolClass
    ^ MyToolView

MyToolAnnouncement >> isUnique
    ^ true  "only one instance of this panel allowed"

MyToolAnnouncement >> on: aModel
    ^ self new
        model: aModel;
        yourself
```

## Announcing It

From an action, a model, or anywhere with access to a notification center:

```smalltalk
"From an action context:"
aContext notificationCenter
    announce: (MyToolAnnouncement on: myModel)

"From a presenter:"
self notificationCenter
    announce: (MyToolAnnouncement on: self model)

"From a browser:"
browser notificationCenter
    announce: (MyToolAnnouncement new model: anObject)
```

## How the Browser Handles It

```smalltalk
PulsarBaseBrowser >> addTool: ann
    ann isUnique ifTrue: [
        (self findPresenterClass: ann toolClass) ifNotNil: [ :aPresenter |
            aPresenter withPanelWidgetDo: [ :aPanelWidget |
                aPanelWidget raiseAndTakeKeyboardFocus ].
            ^ self ] ].

    self addPresenterClass: ann toolClass model: ann model
```

**Behavior:**
1. If `isUnique` is `true` and a presenter of `toolClass` is already docked, raise it and return
2. Otherwise, instantiate `toolClass`, bind `ann model` to it, and dock it

## The `model` Slot

The `model` slot carries the data for the tool. The presenter receives it via `setModel:`:

```smalltalk
ann model: myModel.

"Inside addTool:"
self addPresenterClass: ann toolClass model: ann model

"Which calls:"
view := self instantiate: aClass on: aModel.
```

If the tool doesn't need a model, pass `nil`:

```smalltalk
self notificationCenter announce: (MyToolAnnouncement new model: nil)
```

## `isUnique` — Single vs. Multiple Instances

| `isUnique` | Behavior |
|---|---|
| `true` | Only one instance. Re-announcing raises the existing one. Use for panels like Class Outline, Editor Stack. |
| `false` | Multiple instances allowed. Each announcement creates a new docked panel. Use for multi-instance tools like playprounds, object explorers. |

```smalltalk
MyToolAnnouncement >> isUnique
    ^ false  "multiple playgrounds are fine"
```

## When to Use Request Announcements

| Scenario | Approach |
|---|---|
| User clicks a toolbar button | Action + request announcement |
| A model action wants to open a tool | Announce from the action block |
| A tool wants to open another tool | Announce via notification center |
| The browser wants to ensure a tool is shown | Use `addUniquePresenterClass:model:` instead |

## When NOT to Use

- **Toggle buttons** — use `doToggleTool:fromState:` via `<dockActions>` instead
- **Editors triggered by model activation** — the browser handles this automatically (see chapter 13)
- **Dialogs and modals** — these are not docked panels; use `openModalWithParent:` directly

## Built-In Examples

| Announcement | Tool | Unique |
|---|---|---|
| `PulsarRequestNewPlayground` | `PulsarPlayground` | No (multiple allowed) |
| `PulsarRequestProjectAnnouncement` | `PulsarSingleProjectView` | No |
| `PulsarRequestRepositoryRemotes` | `PulsarRepositoryRemotesView` | Yes |

Note that panels toggled from the View menu (Class Outline, Editor Stack, ...) do **not** use request announcements — they are toggled with `doToggleTool:fromState:` via `<dockActions>` (see chapter 10).

## Requesting a Tool from a Model Action

```smalltalk
MyModel >> defineModelActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #tools with: [ :group |
        group addActionWith: [ :action |
            action
                name: 'Open in My Tool';
                action: [ :aContext |
                    aContext notificationCenter
                        announce: (MyToolAnnouncement on: self) ] ] ]
```

The `aContext` parameter (a `PulsarActionContext`) gives access to the notification center without holding a reference to the browser.

## Requesting a Tool from Anywhere

Since the notification center is the browser's announcer, any presenter bound to that browser can announce and the browser will react. This means a tool in the left sidebar can open a tool in the right sidebar without knowing about it directly.
