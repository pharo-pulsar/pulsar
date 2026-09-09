# 8. Snapshots — Architecture in Depth

Pulsar persists its entire UI state across image saves and restarts through a **snapshot** system. Every presenter, window, and editor can serialize its state into a snapshot object, and later be reconstructed from that snapshot.

## The Snapshot Hierarchy

```
PulsarBaseSnapshot               — abstract base
  ├── PulsarPanelSnapshot        — a single panel widget
  │     ├── PulsarEditorSnapshot       — editor state (class, method, etc.)
  │     ├── PulsarStackSnapshot        — editor stack state
  │     ├── PulsarPlaygroundSnapshot   — playground state
  │     ├── PulsarInspectorSnapshot    — inspector state
  │     ├── PulsarMessageSnapshot      — message browser state
  │     ├── PulsarHierarchySnapshot    — hierarchy view state
  │     ├── PulsarProjectSnapshot      — project view state
  │     ├── PulsarDirectorySnapshot    — directory browser state (Pulsar-Tool-FileEditor)
  │     └── PulsarRepositoriesSnapshot — repositories view state (Pulsar-Tool-Repositories)
  ├── PulsarPresenterWithModelSnapshot — presenter + its model
  ├── PulsarApplicationSnapshot  — all open windows
  ├── PulsarBaseBrowserSnapshot  — base browser state
  │     ├── PulsarBrowserSnapshot         — main IDE browser
  │     ├── PulsarRepositoryBrowserSnapshot — repository browser (Pulsar-Tool-Repositories)
  │     ├── PulsarDetachedBrowserSnapshot  — detached browser
  │     └── PulsarDebuggerSnapshot         — debugger state
  └── PulsarWindowSnapshot       — a single window
```

## PulsarBaseSnapshot

```smalltalk
PulsarBaseSnapshot
    package: 'Pulsar-Browser'
```

The abstract root. Defines the protocol all snapshots must implement:

```smalltalk
"Serialization: called when saving state"
PulsarBaseSnapshot >> snapshot: anObject
    "Subclasses override to capture anObject's state into instance variables."

"Deserialization: called when restoring state"
PulsarBaseSnapshot >> restoreTo: anObject
    "Subclasses override to rebuild anObject's state from instance variables."

"Priority: order in which snapshots are restored"
PulsarBaseSnapshot >> restorePriority
    ^ 100  "default; lower = earlier"

PulsarBrowserSnapshot >> restorePriority
    ^ 1  "the main browser is restored first"
```

## The `snapshot` Method

Every class that composes `PulsarTSnapshot` defines:

```smalltalk
PulsarTSnapshot >> snapshot
    ^ PulsarPanelSnapshot on: self
```

Presenters override this to create more specific snapshot types:

```smalltalk
PulsarBaseBrowser >> snapshot
    ^ PulsarBaseBrowserSnapshot on: self

PulsarBrowser >> snapshot
    ^ PulsarBrowserSnapshot on: self

PulsarEditor >> snapshot
    ^ PulsarEditorSnapshot on: self
```

Each `Snapshot >> on:` class method creates a new snapshot and copies the object's state into it.

## Application-Level Snapshot

### Saving

```smalltalk
PulsarApplicationSnapshot >> snapshot: anApplication
    records := anApplication windows
        reject: [ :each | each isPopover ]
        thenCollect: [ :each | each snapshot ]
```

When the image saves, the application collects snapshots of all non-popover windows. Each window recursively snapshots its presenters.

### Restoring

```smalltalk
PulsarApplicationSnapshot >> restoreTo: anApplication
    anApplication suspendAnnouncementsDuring: [
        (records sorted: #restorePriority ascending)
            collect: [ :each | self restoreWindow: each to: anApplication ]
            thenDo: [ :each | each open ] ]

PulsarApplicationSnapshot >> restoreWindow: aSnapshot to: anApplication
    | window |
    window := aSnapshot instantiateOn: anApplication.
    window notificationCenter
        suspendAllWhile: [ aSnapshot restoreTo: window ].
    ^ window
```

**Restore sequence:**
1. Announcements are globally suspended
2. Snapshots are sorted by `restorePriority` (lower = earlier)
3. Each window is **instantiated** (created empty) then **restored** (filled with state)
4. During restoration, the window's own notification center is also suspended
5. After all are restored, windows are opened (they then start receiving events)

## What Gets Snapshotted

| State | Example | How |
|---|---|---|
| Panel area sizes | start/end widths, bottom height | `PulsarBaseBrowserSnapshot` (captures startWidth/endWidth/bottomHeight) |
| Docked panels | Which panels are open, their positions | `PulsarBaseBrowserSnapshot` (one panel snapshot per presenter) |
| Open editors | Editor type, model, cursor position, dirty text | `PulsarEditorSnapshot` |
| Editor stack | Stack order, sorting selector, pinned editors | `PulsarStackSnapshot` (sortingSelector) + `PulsarPanelSnapshot` (pinned) |
| Debugger state | Same state as a browser window | `PulsarDebuggerSnapshot` (only overrides `browserClass`) |
| Playground state | Cursor position, lasting bindings | `PulsarPlaygroundSnapshot` (code is NOT captured) |
| Windows | Window content, panel layout | `PulsarWindowSnapshot` (delegates to the inner browser snapshot) |

## What Does NOT Get Snapshotted

- **Popovers and modals** — dialogs are excluded
- **Transient UI state** — hover states, animations, tooltips
- **Model data that can be recomputed** — models are lightweight wrappers; the entity reference (identity) is stored, not the full model

## Model Snapshots

Models use `PulsarTModelSnapshot`:

```smalltalk
PulsarTModelSnapshot >> prepareForSnapshot
    "Called before snapshotting. Clean up transient state."
```

The trait's hook is empty; models override it to clean up what should not be kept (e.g. transient caches). The model **instance itself** is stored in the snapshot (`PulsarPanelSnapshot >> takeModelSnapshot:`), not a reference to its entity. On restore, the presenter is recreated from that stored model via `instantiateOn:`.

## Snapshot Lifecycle Summary

```
Image about to save
    │
    ▼
PulsarApplication >> snapshot
    │
    ▼
PulsarApplicationSnapshot >> snapshot: (collects window snapshots)
    │
    ▼
Each window >> snapshot (recursively snapshots presenters)
    │
    ▼
Each presenter >> snapshot (copies state into snapshot object)
    │
    ▼
Image saved ──────► Image restarted
                       │
                       ▼
                   PulsarApplication >> start
                       │
                       ▼
                   PulsarApplicationSnapshot >> restoreTo:
                       │
                       ▼
                   Each window restored → initialized → opened
                       │
                       ▼
                   PulsarBaseBrowserSnapshot >> restorePanelSnapshot: (rebuilds UI from state)
```

## Adding Snapshot Support to a New Presenter

```smalltalk
MyToolPresenter >> snapshot
    ^ MyToolSnapshot on: self

MyToolSnapshot >> snapshot: aPresenter
    super snapshot: aPresenter.
    myState := aPresenter myState copy.

MyToolSnapshot >> restoreTo: aPresenter
    super restoreTo: aPresenter.
    aPresenter myState: myState
```

The key contract:
- `snapshot` on the presenter creates a snapshot object via its class-side `on:` and calls `snapshot:` on it
- On restore, `PulsarBaseBrowserSnapshot >> restorePanelSnapshot:` instantiates the presenter from the stored class and model (`instantiateOn:`), adds it at the stored `panelPosition` (`addPresenter:at:`), and then calls `restoreTo:` on the snapshot
- The snapshot subclass stores only what needs to survive a restart; the base `PulsarPanelSnapshot` already covers presenter class, dock position, pinned state, and the model
