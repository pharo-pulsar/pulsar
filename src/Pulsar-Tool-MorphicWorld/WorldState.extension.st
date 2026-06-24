Extension { #name : 'WorldState' }

{ #category : '*Pulsar-Tool-MorphicWorld' }
WorldState class >> quitSession [
	| response |
	
	PulsarMorphicWorldActivator uniqueInstance ifActive: [ :activator | 
		activator deactivate.
		^ self ].
	
	response := MorphicUIManager new
		confirm: 'Save changes before quitting?'
		trueChoice: 'Save'
		falseChoice: 'Discard'
		cancelChoice: 'Cancel'
		default: nil.
	response ifNil: [ ^self ].
	response
		ifTrue: [Smalltalk snapshot: true andQuit: true]
		ifFalse: [Smalltalk snapshot: false andQuit: true]
]

{ #category : '*Pulsar-Tool-MorphicWorld' }
WorldState class >> saveAndQuit [

	PulsarMorphicWorldActivator uniqueInstance ifActive: [ :activator | 
		Smalltalk snapshot: true andQuit: false.
		1 second wait.
		activator deactivate.
		^ self ].

	Cursor write showWhile: [
		Smalltalk snapshot: true andQuit: true ]
]
