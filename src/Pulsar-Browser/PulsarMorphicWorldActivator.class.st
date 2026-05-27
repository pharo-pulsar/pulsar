"
An utility to activate/deactivate the Morphic World.

Currently just usable in Linux.
"
Class {
	#name : 'PulsarMorphicWorldActivator',
	#superclass : 'Object',
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

{ #category : 'actions' }
PulsarMorphicWorldActivator >> activate [
	"Start the Morphic World using SDL2/OSWorldRenderer.
	 This allows using the classic Morphic environment alongside Pulsar."
	| renderer |
	
	self isActive ifTrue: [ ^ self ].	

	"Restart morphic UI process, or spawn fresh if none"
	MorphicUIManager uiProcess 
		ifNotNil: [ MorphicUIManager restartMethods ] 
		ifNil: [ MorphicUIManager new spawnNewProcess ]. 
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
	renderer deactivate. 
	"Kill the SDL2 event loop process"
	renderer driver ifNotNil: [ :d | d shutdownEventLoop ]. 
	"Replace with no-op renderer (same state as before start)"
	World worldState worldRenderer: (NullWorldRenderer forWorld: World). 
	"Terminate uiProcess without nilling (so restartMethods works on next start)"
	process := MorphicUIManager uiProcess.
	process ifNotNil: [
		process suspend; terminate ]
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
