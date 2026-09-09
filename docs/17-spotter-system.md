# 17. Spotter System

Pulsar's **Spotter** is a global search and navigation popup (inspired by pharo `Spotter` widget).

```smalltalk
PulsarSpotter
    package: 'Pulsar-Browser'
```

## Opening the Spotter

From any browser:

```smalltalk
browser showSpotterOn: #environment  "search the environment"
browser showSpotterOn: #commands     "search available commands"
browser showSpotterOn: #windows      "search open windows/editors"
```

The spotter opens as a modal popover centered on the parent window.

## PulsarSpotterModel

```smalltalk
PulsarSpotterModel
    superclass: PvSpotterModelForEnvironment
    package: 'Pulsar-Browser'
```

The model is a thin subclass of `PvSpotterModelForEnvironment` (Perspective) that answers which processors apply to a given search context:

```smalltalk
PulsarSpotterModel >> processorsForContext: aContext
    ^ aContext associatedProcessors

PulsarSpotterModel >> candidatesFor: text inContext: aPulsarSpotterContext
    | candidateList stream context processor |
    candidateList := StSpotterCandidatesList new.
    stream := StSpotterStream new receiver: candidateList; yourself.
    context := StSpotterContext new
        step: self;
        stream: stream;
        text: text;
        search: text;
        yourself.
    (self processorsForContext: aPulsarSpotterContext) do: [ :each |
        processor := each newEnvironment: Smalltalk environment.
        processor prepareFor: aPulsarSpotterContext.
        processor filterInContext: context ].
    ^ candidateList candidates asArray
```

Each processor is instantiated, prepared for the tab context, and asked to filter into a `StSpotterCandidatesList`. The search orchestration (when to re-run this) lives in the **presenter** (`PulsarSpotter`), not in the model — see Incremental Search below.

## Search Processors

The spotter has three tabs, each described by a `PulsarSpotterSearch*Context` class. A context declares which processors contribute results to its tab (`associatedProcessors`) and its search placeholder:

| Context (tab) | Processors | Searches |
|---|---|---|
| `PulsarSpotterSearchEnvironmentContext` | `PvUnifiedProcessor` | Packages, classes, methods, projects |
| `PulsarSpotterSearchEditorsContext` | `PulsarEditorsProcessor` | Open editor tabs |
| `PulsarSpotterSearchToolsContext` | `PvWorldMenuProcessor` | Available tool panels / commands |

Processors are subclasses of `StSpotterProcessor`. Each processor implements:

- `prepareFor:` — set up for a search session
- `newTextFilteringSource` — return a filtered data source for incremental search
- `showForEmptyQuery` — whether to show results when no query is entered
- `isRelevantForQuery:` — whether this processor applies to the current search category

## Incremental Search

The spotter uses a `TKTParameterizableService` for incremental search — a repeating task that re-runs while the user types:

```smalltalk
PulsarSpotter >> ensureSearchService
    searchService := TKTParameterizableService new.
    searchService
        name: 'PulsarSpotter service: ' , UUID new asString;
        stepDelay: 100 milliSeconds;
        step: [ self processSearch ].
    searchService start
```

Every 100 ms (while the spotter is open) the service's step runs `processSearch`, which re-queries the current tab's processors with the current query text. When the spotter is reused, the service is recreated.

```
User types "Array"
    │
    ▼
Service step runs → searches "A"
    ↓
Service step runs → searches "Ar"
    ↓
Service step runs → searches "Arr"
    ↓
Service step runs → searches "Arra"
    ↓
Service step runs → searches "Array" → shows results
```

## PulsarSpotterRow

```smalltalk
PulsarSpotterRow
    package: 'Pulsar-Browser'
```

A row presenter for spotter results. Each result shows an icon, title, and subtitle. Selecting a result navigates to the corresponding model (opening an editor if applicable).

## PulsarEditorsProcessor

```smalltalk
PulsarEditorsProcessor
    package: 'Pulsar-Browser'
```

The processor that searches across open editors. It wraps each editor as a `PulsarPanelEntry`:

```smalltalk
PulsarPanelEntry
    package: 'Pulsar-Browser'
```

## Spotter and Notification Center

The spotter gets its own notification center reference:

```smalltalk
spotter notificationCenter: self notificationCenter
```

This allows it to announce `PulsarModelActivated` when the user selects a result, triggering the browser to open the corresponding editor.

## Adding a Custom Search Processor

```smalltalk
MySpotterProcessor >> prepareFor: aPulsarSpotterContext
    "Set up search state"

MySpotterProcessor >> newTextFilteringSource
    ^ (StCollectionIterator on: self allMyItems)
        asSubstringFilter

MySpotterProcessor >> showForEmptyQuery
    ^ true

MySpotterProcessor >> isRelevantForQuery: categoryQueryPrefix
    ^ categoryQueryPrefix = #myCategory
```
