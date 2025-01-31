Class {
	#name : 'DockMethodActionRunTestDecorator',
	#superclass : 'PvMethodActionDecorator',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'testing' }
DockMethodActionRunTestDecorator class >> appliesTo: aMethod [

	^ aMethod isTestMethod
]

{ #category : 'initialization' }
DockMethodActionRunTestDecorator >> defineAction [

	self name: 'Run Test'.
	self description: 'Execute test of current method/class'.
	self iconCompositeName: 'play'
]

{ #category : 'executing' }
DockMethodActionRunTestDecorator >> execute [

	self context doRunTestCommand: self
]

{ #category : 'accessing' }
DockMethodActionRunTestDecorator >> iconName [

	^ #play
]
