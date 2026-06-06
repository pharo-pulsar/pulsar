"
An utility to activate/deactivate the Morphic World.

Currently just usable in Linux.
"
Class {
	#name : 'PulsarMorphicWorldActivator',
	#superclass : 'Object',
	#traits : 'PulsarTActionContainer',
	#classTraits : 'PulsarTActionContainer classTrait',
	#instVars : [
		'paused',
		'lastExtent',
		'active'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Pulsar-Browser-Utilities',
	#package : 'Pulsar-Browser',
	#tag : 'Utilities'
}

{ #category : 'initialization' }
PulsarMorphicWorldActivator class >> initialize [

	SessionManager default registerSystemClassNamed: self name
]

{ #category : 'accessing' }
PulsarMorphicWorldActivator class >> reset [
	"For testing and cleanup."

	uniqueInstance := nil
]

{ #category : 'session management' }
PulsarMorphicWorldActivator class >> shutDown: quitting [
	"Pause the morphic world before image save to avoid stale OS window handles."

	self uniqueInstance isActive ifFalse: [ ^ self ].
	self uniqueInstance pause
]

{ #category : 'session management' }
PulsarMorphicWorldActivator class >> startUp: isImageStarting [
	"Resume the morphic world after image restart if it was paused."

	self uniqueInstance isPaused ifFalse: [ ^ self ].
	
	self uniqueInstance unpause: isImageStarting
]

{ #category : 'accessing' }
PulsarMorphicWorldActivator class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : 'private' }
PulsarMorphicWorldActivator >> actions [

	^ PulsarActionCollector collectFor: self
]

{ #category : 'actions' }
PulsarMorphicWorldActivator >> activate [
	"Start the Morphic World using SDL2/OSWorldRenderer.
	 This allows using the classic Morphic environment alongside Pulsar."
	| renderer |
	
	self isActive ifTrue: [ ^ self ].	

	self ensureUIProcess.

	"Create and activate the OSWorldRenderer.
	 The setter worldRenderer: calls activate for us, which:
	 - Picks the SDL2 driver
	 - Creates an OSWindow with MorphicEventHandler
	 - Starts the SDL2 event loop" 
	renderer := OSWorldRenderer forWorld: World.
	World worldState worldRenderer: renderer.
	
	active := true.
	paused := false
]

{ #category : 'actions' }
PulsarMorphicWorldActivator >> deactivate [
	"Deactivate for good the morphic world"
	
	self performDeactivate: true
]

{ #category : 'private - definitions' }
PulsarMorphicWorldActivator >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #development with: [ :group | group 
		name: 'Development';
		beDisplayedAsSubMenu;
		priority: 1200;
		addActionWith: [ :action | action 
			name: 'Open Morphic World';
			state: false;
			description: 'Activate/Deactivate the Morphic World';
			action: [ 
				self toggleActivate.
				action state: self isActive ] ];
		addActionWith: [ :action | action 
			name: 'Restart Morphic UI Process';
			description: 'Restart Morphic UI Process (a debugger may kill it)';
			actionEnabled: [ self isActive ];
			action: [ self ensureUIProcess ] ] ]
]

{ #category : 'private' }
PulsarMorphicWorldActivator >> ensureUIProcess [
	"Restart morphic UI process, or spawn fresh if none"

	MorphicUIManager uiProcess 
		ifNotNil: [ MorphicUIManager restartMethods ] 
		ifNil: [ MorphicUIManager new spawnNewProcess ]
]

{ #category : 'initialization' }
PulsarMorphicWorldActivator >> initialize [

	super initialize.
	active := false
]

{ #category : 'testing' }
PulsarMorphicWorldActivator >> isActive [

	^ active
]

{ #category : 'testing' }
PulsarMorphicWorldActivator >> isPaused [

	^ paused == true
]

{ #category : 'private - resuming' }
PulsarMorphicWorldActivator >> pause [
	"Pause the morphic world, cleaning up OS resources while preserving
     the knowledge that it was active (via the paused flag).
     The paused state survives image save/restart."
	| renderer |
	
	self isActive ifFalse: [ ^ self ].

	paused := true.
	
	self stopUIProcess
]

{ #category : 'private' }
PulsarMorphicWorldActivator >> performDeactivate: pauseBoolean [
	"Stop the Morphic World (OSWindow/SDL2) and return to headless Pulsar state.
     This leaves no UI process, no SDL2 event loop, and no OSWindow."
	| renderer |
	
	self isActive ifFalse: [ ^ self ].
	
	active := false.
	paused := pauseBoolean.
	
	renderer := World worldState worldRenderer. 
	lastExtent := renderer osWindow extent.
	"Destroy the OSWindow (closes the window) and release the SDL2 display"
	[ renderer deactivate ]
		on: Error
		do: [ :e | logger error: e ]. 
	"Kill the SDL2 event loop process"
	renderer driver ifNotNil: [ :aDriver | aDriver shutdownEventLoop ]. 
	"Replace with no-op renderer (same state as before start)"
	World worldState worldRenderer: (NullWorldRenderer forWorld: World). 
	"Terminate uiProcess without nilling (so restartMethods works on next start)"
	self stopUIProcess
]

{ #category : 'private' }
PulsarMorphicWorldActivator >> stopUIProcess [
	| process |

	process := MorphicUIManager uiProcess.
	process ifNotNil: [
		process
			suspend;
			terminate ]
]

{ #category : 'actions' }
PulsarMorphicWorldActivator >> toggleActivate [

	self isActive
		ifTrue: [ self deactivate ]
		ifFalse: [ self activate ]
]

{ #category : 'private - resuming' }
PulsarMorphicWorldActivator >> unpause: isImageStarting [
	"Resume the morphic world after a pause (typically after image restart)."
	isImageStarting ifTrue: [
		"for now I do not want to restart the morphic world on restart: let the user doit explicitly"
		active := false ].
	
	self isActive ifFalse: [ ^ self ].

	paused := false.
	
	self ensureUIProcess
]
