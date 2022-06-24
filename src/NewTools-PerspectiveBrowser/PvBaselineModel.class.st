Class {
	#name : #PvBaselineModel,
	#superclass : #PvEntityModel,
	#category : #'NewTools-PerspectiveBrowser-View-Project'
}

{ #category : #visiting }
PvBaselineModel >> accept: aVisitor [
	
	^ aVisitor visitBaselineModel: self
]

{ #category : #accessing }
PvBaselineModel >> name [

	^ self entity name allButFirst: 10 "BaselineOf"
]
