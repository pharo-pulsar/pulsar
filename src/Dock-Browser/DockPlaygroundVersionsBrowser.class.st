Class {
	#name : 'DockPlaygroundVersionsBrowser',
	#superclass : 'DockVersionsBrowser',
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'private - actions' }
DockPlaygroundVersionsBrowser >> activate [
	self error: 'Should not arrive here'
]

{ #category : 'private - actions' }
DockPlaygroundVersionsBrowser >> activateWith: aVersion [

	activationAction ifNil: [ ^ self ].
	activationAction cull: aVersion
]

{ #category : 'actions' }
DockPlaygroundVersionsBrowser >> doRevert [
	| version |
	
	"because after dismissing the popover selected item can no longer exists"
	version := versionListPresenter selectedItem copy.
	self withPopoverDo: #dismiss.
	self activateWith: version
]

{ #category : 'initialization' }
DockPlaygroundVersionsBrowser >> updateSourceCodeWith: aDefinition [
		
	sourcePresenter 
		beForScripting;
		text: aDefinition sourceCode
]
