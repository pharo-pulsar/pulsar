Class {
	#name : 'DockMethodActionRunSampleDecorator',
	#superclass : 'PvMethodActionDecorator',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'testing' }
DockMethodActionRunSampleDecorator class >> appliesTo: aMethod [
	"scripts, examples or sampleInstances are all more or less the same, 
	 they just need to be executed (and sampleInstances needs to be inspected) :)"
	^ (aMethod pragmas collect: [ :each | each selector ]) 
		includes: #sampleInstance
]

{ #category : 'instance creation' }
DockMethodActionRunSampleDecorator class >> on: aModel [

	^  self new 
		model: aModel;
		yourself
]

{ #category : 'accessing' }
DockMethodActionRunSampleDecorator >> contextModel [

	^ context model
]

{ #category : 'initialization' }
DockMethodActionRunSampleDecorator >> defineAction [

	self name: 'Run Sample'.
	self description: 'Execute current method and take a sample instance'.
	self iconCompositeName: 'play'
]

{ #category : 'executing' }
DockMethodActionRunSampleDecorator >> execute [

	self context doRunSampleInstanceCommand: self
]

{ #category : 'accessing' }
DockMethodActionRunSampleDecorator >> iconName [

	^ #play
]
