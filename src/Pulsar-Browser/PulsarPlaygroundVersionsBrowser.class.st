Class {
	#name : 'PulsarPlaygroundVersionsBrowser',
	#superclass : 'PulsarVersionsBrowser',
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'private - actions' }
PulsarPlaygroundVersionsBrowser >> activate [
	self error: 'Should not arrive here'
]

{ #category : 'private - actions' }
PulsarPlaygroundVersionsBrowser >> activateWith: aVersion [

	activationAction ifNil: [ ^ self ].
	activationAction cull: aVersion
]

{ #category : 'private - definitions' }
PulsarPlaygroundVersionsBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>
	
	"nothing for now, just overriding my parent."
]

{ #category : 'actions' }
PulsarPlaygroundVersionsBrowser >> doRevert [
	| version |
	
	"because after dismissing the popover selected item can no longer exists"
	version := versionListPresenter selectedItem copy.
	self withPopoverDo: #dismiss.
	self activateWith: version
]

{ #category : 'initialization' }
PulsarPlaygroundVersionsBrowser >> updateSourceCodeWith: aDefinition [
		
	sourcePresenter 
		beForScripting;
		text: aDefinition sourceCode
]
