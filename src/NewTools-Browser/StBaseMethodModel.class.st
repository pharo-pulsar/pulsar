Class {
	#name : #StBaseMethodModel,
	#superclass : #StBaseModel,
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #actions }
StBaseMethodModel >> compile: aString notifying: requestor [

	self methodClass 
		compile: aString
		classified: self methodCategory
		notifying: requestor
]

{ #category : #testing }
StBaseMethodModel >> isTemplate [

	^ false
]

{ #category : #accessing }
StBaseMethodModel >> methodCategory [

	self subclassResponsibility
]

{ #category : #accessing }
StBaseMethodModel >> methodClass [

	self subclassResponsibility
]

{ #category : #accessing }
StBaseMethodModel >> sourceCode [

	self subclassResponsibility
]
