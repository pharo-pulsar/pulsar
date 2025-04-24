Class {
	#name : 'DockMethodActionRunScriptDecorator',
	#superclass : 'PvMethodActionDecorator',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'testing' }
DockMethodActionRunScriptDecorator class >> appliesTo: aMethod [
	"scripts, examples or sampleInstances are all more or less the same, 
	 they just need to be executed (and sampleInstances needs to be inspected) :)"
	^ (aMethod pragmas collect: [ :each | each selector ]) 
		includesAny: #(script example)
]

{ #category : 'instance creation' }
DockMethodActionRunScriptDecorator class >> on: aModel [

	^  self new 
		model: aModel;
		yourself
]

{ #category : 'accessing' }
DockMethodActionRunScriptDecorator >> contextModel [

	^ context model
]

{ #category : 'initialization' }
DockMethodActionRunScriptDecorator >> defineAction [

	self name: 'Run Script'.
	self description: 'Execute current method'.
	self iconCompositeName: 'play'.
	"self presenterClass: DockMethodActionRunTestPresenter"
]

{ #category : 'executing' }
DockMethodActionRunScriptDecorator >> execute [

	self context doRunScriptCommand: self
]

{ #category : 'accessing' }
DockMethodActionRunScriptDecorator >> iconName [

	^ #play
]
