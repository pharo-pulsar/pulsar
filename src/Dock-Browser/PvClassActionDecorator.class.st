Class {
	#name : 'PvClassActionDecorator',
	#superclass : 'PvActionDecorator',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing' }
PvClassActionDecorator class >> allApplyingTo: aModel [
	
	"avoid a copy since I know I will not modify it"
	^ self basicSubclasses
		select: [ :each | each appliesTo: aModel entity ]
		thenCollect: [ :each | each new ]
]

{ #category : 'testing' }
PvClassActionDecorator class >> appliesTo: aClass [

	^ false
]
