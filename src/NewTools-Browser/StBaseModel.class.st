Class {
	#name : #StBaseModel,
	#superclass : #Object,
	#category : #'NewTools-Browser-Model'
}

{ #category : #accessing }
StBaseModel >> name [

	^ self subclassResponsibility
]

{ #category : #'instance creation' }
StBaseModel >> newEditors [
	
	^ #()
]

{ #category : #accessing }
StBaseModel >> shortName [

	^ self name
]

{ #category : #accessing }
StBaseModel >> windowName [

	^ self name
]
