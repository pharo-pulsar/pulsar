# 20. Debugger

Pulsar includes a native debugger built on the same browser architecture as the rest of the IDE. It opens in its **own window** (it is a `PulsarBaseBrowser` subclass, not a docked panel).

```smalltalk
PulsarDebugger
    superclass: PulsarBaseBrowser
    slots: { stackView. contextEditor. debugToolbarPresenter }
    package: 'Pulsar-Browser'
```

## Architecture

```
PulsarDebugger (a browser, opens as its own window)
    │
    │ model:
    ▼
PulsarDebuggerModel (wraps a debug session)
    │
    ├── stackView: PulsarContextStackPresenter
    │
    ├── debugToolbarPresenter: PulsarDebuggerToolbarPresenter
    │
    ├── PulsarDebuggerContextInspector   (panel: inspector for the current context)
    │
    └── PulsarDebuggerReceiverInspector  (panel: inspector for the receiver/self)
```

`PulsarDebugger >> initializeDefaultWorkspace` sets up the three docked views:

```smalltalk
PulsarDebugger >> initializeDefaultWorkspace
    stackView := self addPresenterClass: PulsarContextStackPresenter.
    self addPresenterClass: PulsarDebuggerReceiverInspector.
    self addPresenterClass: PulsarDebuggerContextInspector
```

## PulsarDebugger

The debugger is opened from a session:

```smalltalk
PulsarDebugger >> debugSession: aDebugSession
    self session: aDebugSession.
    self open
```

It shows the stack trace, allows stepping through code, and inspects variables in the current context.

## PulsarDebuggerModel

```smalltalk
PulsarDebuggerModel
    superclass: PvBaseModel
    slots: { session. stack. actionModel }
    package: 'Pulsar-Browser'
```

Wraps a Pharo debug session and provides:

- `on:` (class side) — `^ self new session: aSession; yourself`
- `session` / `session:` — the wrapped debug session
- `stack` — lazily built list of `PulsarContextModel` (one per stack frame):

```smalltalk
PulsarDebuggerModel >> stack
    ^ stack ifNil: [
        stack := (self actionModel filterStack: self session stack)
            collect: [ :each |
                PulsarContextModel newEnvironment: self environmentModel
                    debuggerModel: self
                    context: each ] ]
```

- `resetStack` — `stack := nil` (forces the stack to be rebuilt)
- `clearSession` — releases the session

## PulsarDebuggerContextInspector / PulsarDebuggerReceiverInspector

```smalltalk
PulsarDebuggerContextInspector
    superclass: PulsarDebuggerInspector
    package: 'Pulsar-Browser'
```

The context inspector shows local variables (`self`, arguments, temps) for the selected stack frame. The receiver inspector shows the receiver object, allowing navigation of its instance variables. Both are `PulsarDebuggerInspector` subclasses with no extra state.

## Debugger Toolbar

```smalltalk
PulsarDebuggerToolbarPresenter
    superclass: SpPresenter
    uses: SpTModel
    slots: { toolbarActions. toolbarPresenter. debugger. lastOwner. contextToolbarPresenter. model }
    package: 'Pulsar-Browser'
```

The toolbar commands:

- **Step Into** (`stepInto`) — enter the next message send
- **Step Over** (`stepOver`) — execute the current message and stop at the next
- **Step Through** (`stepThrough`) — execute without entering blocks
- **Proceed** (`proceedDebugSession`) — continue execution
- **Restart** (`restartCurrentContext`) — restart the current context
- **Return entered value** (`returnEnteredValue`)
- **Run to selection** (`runToSelection`)

When the current context changes, the toolbar announces it:

```smalltalk
PulsarDebuggerToolbarPresenter >> announceContextChangedUpdateTopContext: aBoolean
    self notifyContextChanged: (PulsarDebuggerContextChanged new
        updateTopContext: aBoolean)
```

## PulsarDebuggerContextChanged

```smalltalk
PulsarDebuggerContextChanged
    superclass: PulsarAnnouncement
    slots: { updateTopContext }
    package: 'Pulsar-Browser'
```

Announced when the user selects a different stack frame. `updateTopContext` tells the debugger whether the top context of the stack must also be updated. Listeners (`PulsarDebugger >> eventContextChanged:`) refresh the context inspector for the new frame.

## PulsarDebuggerSnapshot

```smalltalk
PulsarDebuggerSnapshot
    superclass: PulsarBaseBrowserSnapshot
    package: 'Pulsar-Browser'
```

Restoring a debugger is handled entirely by the generic browser snapshot machinery (chapter 8). The only override tells the snapshot which browser to instantiate:

```smalltalk
PulsarDebuggerSnapshot >> browserClass
    ^ PulsarDebugger
```

## PulsarSingleDebuggerSelector

```smalltalk
PulsarSingleDebuggerSelector
    superclass: OupsSingleDebuggerSelector
    slots: { application }
    package: 'Pulsar-Browser'
```

This is the Oups **debugger-selection strategy** installed by `PulsarApplication >> prepareErrorHandlerAsStandaloneApplication` (chapter 5). When Oups needs a debugger, it answers a new Pulsar debugger:

```smalltalk
PulsarSingleDebuggerSelector >> nextDebugger
    ^ PulsarDebugger newApplication: application
```

## MCP Integration

```smalltalk
MCPToolPulsarDebugger
    package: 'Pulsar-Tool-LLM'
```

The debugger is also exposed through the MCP server for external tool access (e.g., LLM agents).

## Debugger Lifecycle

1. An unhandled exception occurs
2. `PulsarErrorHandler` submits an `OupsDebugRequest` (chapter 5)
3. Oups asks the selection strategy (`PulsarSingleDebuggerSelector`) for a debugger
4. `PulsarDebugger >> debugSession:` wraps the session in a `PulsarDebuggerModel` and opens the debugger window
5. User inspects, steps, debugs
6. `proceed` or `restart` continues or restarts execution
