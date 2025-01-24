Class {
	#name : 'PvMethodActionDecorator',
	#superclass : 'PvAction',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvMethodActionDecorator class >> allApplyingTo: aMethod [
	
	"avoid a copy since I know I will not modify it"
	^ self basicSubclasses
		select: [ :each | each appliesTo: aMethod ]
		thenCollect: [ :each | each new ]
]

{ #category : 'testing' }
PvMethodActionDecorator class >> appliesTo: aMethod [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
PvMethodActionDecorator >> defineAction [

	self name: 'Run Test'.
	self description: 'Execute test of current method/class'.
	self iconCompositeName: 'play'
]

{ #category : 'executing' }
PvMethodActionDecorator >> execute [

	self context doRunTestCommand: self
]
