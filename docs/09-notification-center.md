# 9. Notification Center Infrastructure

Pulsar uses Pharo's **announcement** system for all cross-component communication. Each browser has its own notification center (an announcer instance), and presenters subscribe to announcements to react to system events, user actions, and model changes.

## The Announcer

Every `PulsarBaseBrowser` creates a private announcer:

```smalltalk
PulsarBaseBrowser >> initializePrivateAnnouncer
    announcer := PulsarTaskAnnouncer new
```

`PulsarTaskAnnouncer` is an `Announcer` subclass with `PulsarTTaskWorker` that delivers announcements asynchronously on its own worker thread (`queueTask:`). This avoids UI thread safety issues. Two exceptions go straight through `super announce:` synchronously: announcements marked as synchronic (`SpWindowWillClose`, `PulsarModelDeactivated`) and anything announced while the announcer is suspended.

## PulsarNotificationCenterDelegate

```smalltalk
PulsarNotificationCenterDelegate
    slots: { target }
    package: 'Pulsar-Browser'
```

This is a **proxy/delegate** that forwards all announce and subscribe calls to an underlying `target` announcer. It exists so that a presenter's notification center can be transparently swapped at runtime.

```smalltalk
"Create a delegate wrapping an announcer"
PulsarNotificationCenterDelegate >> on: anAnnouncer
    ^ self new target: anAnnouncer; yourself

"All calls are forwarded"
PulsarNotificationCenterDelegate >> announce: anAnnouncement
    target ifNotNil: [ target announce: anAnnouncement ]

PulsarNotificationCenterDelegate >> when:send:to:
    target ifNotNil: [ target when: anAnnouncementClass send: aSelector to: anObject ]
```

## PulsarTNotificationCenter

The trait that gives presenters access to a notification center:

```smalltalk
"Slot: notificationCenter"

PulsarTNotificationCenter >> notificationCenter
    ^ notificationCenter ifNil: [ notificationCenter := PulsarNULLAnnouncer new ]

PulsarTNotificationCenter >> notificationCenter: anAnnouncer
    self basicNotificationCenter: anAnnouncer

PulsarTNotificationCenter >> basicNotificationCenter: anAnnouncer
    (anAnnouncer isKindOf: PulsarNotificationCenterDelegate)
        ifTrue: [ notificationCenter := anAnnouncer ]
        ifFalse: [
            (notificationCenter isKindOf: PulsarNotificationCenterDelegate)
                ifTrue: [ notificationCenter target: anAnnouncer ]
                ifFalse: [ notificationCenter := PulsarNotificationCenterDelegate on: anAnnouncer ] ]
```

The setter is smart: if the incoming announcer is already a delegate, use it directly. If it's a raw announcer, either swap the delegate's target (if one exists) or create a new delegate. This allows embedded views to reuse their parent's announcer without re-registering subscriptions.

## Binding to the Browser

When a presenter is added to a browser, it binds its notification center to the browser's:

```smalltalk
PulsarTNotificationCenter >> registerToBrowser: aPulsarBrowser
    self notificationCenter: aPulsarBrowser notificationCenter
```

This is called from `PulsarBaseBrowser>>#addWindow:`, connecting the new window/presenter to the browser's announcement bus.

## The Browser's Subscriptions

The browser subscribes to several announcement types to manage its panels and editors:

```smalltalk
PulsarBaseBrowser >> registerToEvents
    self announcer
        "Broadcast to all presenters"
        when: PulsarThemeChanged, PulsarSyntaxHighlightThemeChanged, PulsarAnnouncement
            send: #resendAnnouncement: to: self;
        "Model activation/deactivation"
        when: PulsarModelActivated send: #eventModelActivated: to: self;
        when: PulsarModelDeactivated send: #eventModelDeactivated: to: self;
        when: PulsarManyModelDeactivated send: #eventManyModelDeactivated: to: self;
        "Tool requests"
        when: PulsarRequestToolAnnouncement send: #addTool: to: self

PulsarBaseBrowser >> registerToSystemEvents
    self announcer
        when: JobStart send: #eventJobStart: to: self;
        when: JobEnd send: #eventJobEnd: to: self;
        when: SystemAnnouncement, MetacelloExecutionAnnouncement
            send: #resendAnnouncement: to: self
```

### Resending Announcements

```smalltalk
PulsarBaseBrowser >> resendAnnouncement: anAnnouncement
    self presentersDo: [ :aWindowPresenter |
        aWindowPresenter presenter announce: anAnnouncement ]
```

This is the **broadcast** mechanism: the browser receives a system-level or theme announcement and forwards it to every docked presenter. Each presenter can subscribe individually.

## Key Announcement Classes

### Model Events

| Announcement | When Emitted |
|---|---|
| `PulsarModelActivated` | A model is opened (double-clicked, Enter) |
| `PulsarModelDeactivated` | A model's editor is closed |
| `PulsarManyModelDeactivated` | Multiple models deactivated at once |
| `PulsarModelSelected` | A model is highlighted/clicked |
| `PulsarModelChanged` | A model's underlying entity has changed |
| `PulsarModelRemoved` | A model's entity has been removed from the system |
| `PulsarClassModelSelected` | A class model specifically was selected |
| `PulsarMethodModelSelected` | A method model specifically was selected |

### Tool Events

| Announcement | When Emitted |
|---|---|
| `PulsarRequestToolAnnouncement` | A tool panel should be opened |
| `PulsarRequestNewPlayground` | A new playground should be created |
| `PulsarRequestProjectAnnouncement` | A project should be opened |
| `PulsarPanelActivated` | A panel was activated/focused |
| `PulsarEditorActivated` | An editor was activated |
| `PulsarEditorModified` | An editor's content was modified |
| `PulsarEditorClosed` | An editor was closed |

### System Events

| Announcement | When Emitted |
|---|---|
| `PulsarThemeChanged` | The UI theme changed |
| `PulsarSyntaxHighlightThemeChanged` | The syntax highlighting theme changed |
| `PulsarAnnouncement` | Base class for all Pulsar announcements |
| `PulsarBindingRemoved` | A workspace binding was removed |
| `PulsarLostChangesAnnouncement` | Unsaved changes were lost |

## Subscribing from a Presenter

```smalltalk
MyPresenter >> initialize
    super initialize.
    self notificationCenter
        when: PulsarModelSelected do: [ :ann | self onModelSelected: ann model ];
        when: PulsarThemeChanged do: [ :ann | self updateTheme ]
```

No explicit unsubscription is needed: the announcer holds **weak** subscriptions, so a removed panel and its subscriptions are garbage-collected together. (`PulsarBaseView >> windowClosed` is an empty hook available to subclasses for extra cleanup.)

## Suspending Announcements

During snapshot restore, announcements are suspended to avoid triggering reactions on half-built windows:

```smalltalk
PulsarNotificationCenterDelegate >> suspendAllWhile: aBlock
    target ifNotNil: [ target suspendAllWhile: aBlock ]
```

This is critical: if announcements fired during restore, the browser could try to open editors for models that haven't been fully restored yet.

## Communication Rule

**Presenters should never hold direct references to other presenters.** All cross-presenter communication flows through announcements on the notification center. This keeps views decoupled:

- A tool panel doesn't need to know which browser it's docked in
- An editor doesn't need to know which outline view selected its model
- A panel can be replaced or moved without breaking other views
