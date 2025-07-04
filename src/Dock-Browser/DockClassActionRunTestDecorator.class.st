Class {
	#name : 'DockClassActionRunTestDecorator',
	#superclass : 'PvClassActionDecorator',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'testing' }
DockClassActionRunTestDecorator class >> appliesTo: aClass [

	^ aClass isTestCase and: [ aClass isAbstract not ]
]

{ #category : 'accessing' }
DockClassActionRunTestDecorator >> contextModel [

	^ context model
]

{ #category : 'initialization' }
DockClassActionRunTestDecorator >> defineAction [

	self name: 'Run Test'.
	self description: 'Execute test of current class'.
	self iconCompositeName: 'play'.
	self presenterClass: DockMethodActionRunTestPresenter
]

{ #category : 'executing' }
DockClassActionRunTestDecorator >> execute [

	self context doRunTestCommand: self
]

{ #category : 'accessing' }
DockClassActionRunTestDecorator >> iconName [

	^ #play
]
