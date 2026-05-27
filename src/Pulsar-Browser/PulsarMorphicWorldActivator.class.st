"
An utility to activate/deactivate the Morphic World.

Currently just usable in Linux.
"
Class {
	#name : 'PulsarMorphicWorldActivator',
	#superclass : 'Object',
	#traits : 'PulsarTActionContainer',
	#classTraits : 'PulsarTActionContainer classTrait',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Pulsar-Browser-Extras',
	#package : 'Pulsar-Browser',
	#tag : 'Extras'
}

{ #category : 'accessing' }
PulsarMorphicWorldActivator class >> reset [
	"For testing and cleanup."

	uniqueInstance := nil
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
	World worldState worldRenderer: (OSWorldRenderer forWorld: World)
]

{ #category : 'actions' }
PulsarMorphicWorldActivator >> deactivate [
	"Stop the Morphic World (OSWindow/SDL2) and return to headless Pulsar state.
	 This leaves no UI process, no SDL2 event loop, and no OSWindow."
	| renderer process |
	
	self isActive ifFalse: [ ^ self ].
	
	renderer := World worldState worldRenderer.
	"Destroy the OSWindow (closes the window) and release the SDL2 display"
	[ renderer deactivate ]
	on: Error 
	do: [ :e | logger error: e. "eat it" ].
	"Kill the SDL2 event loop process"
	renderer driver ifNotNil: [ :aDriver | aDriver shutdownEventLoop ]. 
	"Replace with no-op renderer (same state as before start)"
	World worldState worldRenderer: (NullWorldRenderer forWorld: World). 
	"Terminate uiProcess without nilling (so restartMethods works on next start)"
	process := MorphicUIManager uiProcess.
	process ifNotNil: [
		process suspend; terminate ]
]

{ #category : 'private - definitions' }
PulsarMorphicWorldActivator >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #development with: [ :group | group 
		name: 'Development';
		beDisplayedAsSubMenu;
		priority: 1200;
		addActionWith: [ :action | action 
			name: 'Morphic World';
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

{ #category : 'testing' }
PulsarMorphicWorldActivator >> isActive [
	| renderer |
	
	renderer := World worldState worldRenderer.
	^ renderer class ~= NullWorldRenderer
]

{ #category : 'actions' }
PulsarMorphicWorldActivator >> toggleActivate [

	self isActive
		ifTrue: [ self deactivate ]
		ifFalse: [ self activate ]
]
