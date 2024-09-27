Class {
	#name : 'PvSpecToggleCommand',
	#superclass : 'PvSpecCommand',
	#category : 'Perspective-Command-Base',
	#package : 'Perspective',
	#tag : 'Command-Base'
}

{ #category : 'visiting' }
PvSpecToggleCommand >> acceptVisitor: aVisitor [

	^ aVisitor visitToggleCommand: self
]

{ #category : 'accessing' }
PvSpecToggleCommand >> state [
	
	^ self decoratedCommand state
]

{ #category : 'accessing' }
PvSpecToggleCommand >> state: aBoolean [
	
	self decoratedCommand state: aBoolean
]

{ #category : 'accessing' }
PvSpecToggleCommand >> toggleState [
	
	self decoratedCommand toggleState
]
