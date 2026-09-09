# 16. How to Create a New Tool Package

Pulsar tool packages follow the `Pulsar-Tool-*` naming convention and are organized in `BaselineOfPulsar`.

## Package Naming

```
Pulsar-Tool-<ThingName>
```

Examples: `Pulsar-Tool-Repositories`, `Pulsar-Tool-TestRunner`, `Pulsar-Tool-FileEditor`, `Pulsar-Tool-LLM`.

## Step-by-Step Recipe

### 1. Create the Package

```smalltalk
"Create it in the image:"
PackageOrganizer default ensurePackage: 'Pulsar-Tool-MyThing'
```

To also add package tags (Pulsar packages are organized in tags such as `Model` or `View-MyThing`):

```smalltalk
PackageOrganizer default
    ensurePackage: 'Pulsar-Tool-MyThing'
    withTags: #( 'Model' 'View-MyThing' )
```

Add it to a repository via Iceberg.

### 2. Create the Model

Subclass `PvBaseModel` (in `Pulsar-Tool-MyThing` or `Pulsar-Browser` depending on coupling):

```smalltalk
PvBaseModel subclass: #MyThingModel
    slots: { }
    classVariables: { }
    package: 'Pulsar-Tool-MyThing'

MyThingModel >> name
    ^ 'My Thing'

MyThingModel >> iconName
    ^ #myThing
```

Keep the model in the tool package if it's specific to that tool. Move it to `Pulsar-Browser` if other tools or the browser need to reference it.

### 3. Create the Presenter

Subclass `PulsarBaseView` (for panels) or `PulsarEditor` (for editors):

```smalltalk
PulsarBaseView subclass: #MyThingView
    slots: { }
    uses: PulsarTControlUpdate
    package: 'Pulsar-Tool-MyThing'

MyThingView class >> defaultPanelPosition
    ^ SpPanelPosition endArea
```

### 4. Create the Request Announcement (If Needed)

```smalltalk
PulsarRequestToolAnnouncement subclass: #MyThingAnnouncement
    package: 'Pulsar-Tool-MyThing'

MyThingAnnouncement >> toolClass
    ^ MyThingView

MyThingAnnouncement >> isUnique
    ^ true
```

### 5. Add Actions

Add `<dockActions>` methods to your model or presenter:

```smalltalk
MyThingModel >> defineThingActionsOn: aBuilder
    <dockActions>
    aBuilder addGroup: #thing with: [ :group |
        group priority: 700.
        group addActionWith: [ :action |
            action
                name: 'Open Thing';
                action: [ :ctx |
                    ctx notificationCenter
                        announce: (MyThingAnnouncement on: self) ] ] ]
```

### 6. Register in the Baseline

Add your package to `BaselineOfPulsar`:

```smalltalk
BaselineOfPulsar >> baseline: spec
    <baseline>
    spec for: #common do: [
        ...
        spec package: 'Pulsar-Tool-MyThing' ]
```

### 7. Add a Toggle Button (Optional)

Add to `PulsarBaseBrowser>>#defineViewActionsOn:`:

```smalltalk
action name: 'My Thing';
    actionState: [ :aContext | aContext hasPresenterClass: MyThingView ];
    action: [ self doToggleTool: MyThingView fromState: action state ]
```

## Packaging Rules

| Artifact | Where |
|---|---|
| Domain models (entity wrappers) | `Pulsar-Tool-MyThing` or `Pulsar-Browser` |
| UI presenters | `Pulsar-Tool-MyThing` |
| Request announcements | `Pulsar-Tool-MyThing` |
| Announcement classes (non-request) | `Pulsar-Browser` if used by multiple tools |
| Action registration | In model or presenter in `Pulsar-Tool-MyThing` |
| Baseline entry | `BaselineOfPulsar` |

## What Makes a Good Tool Package

- **Self-contained**: the package should load and work without requiring changes to other packages (except the baseline entry)
- **Model first**: define the model before the presenter
- **Snapshot-aware**: persist state so the tool survives image restarts
- **Announcement-driven**: communicate via the notification center, not direct references
- **TaskIt for background work**: never block the UI thread
