Class {
	#name : #StBaseModel,
	#superclass : #Object,
	#category : #'NewTools-Browser-Model'
}

{ #category : #default }
StBaseModel >> name [

	^ self subclassResponsibility
]

{ #category : #default }
StBaseModel >> shortName [

	^ self name
]

{ #category : #default }
StBaseModel >> windowName [

	^ self name
]
