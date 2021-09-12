Class {
	#name : #StBasePackageModel,
	#superclass : #Object,
	#category : #'NewTools-Browser-Model'
}

{ #category : #accessing }
StBasePackageModel >> children [

	^ #()
]

{ #category : #accessing }
StBasePackageModel >> classes [

	^ nil
]

{ #category : #accessing }
StBasePackageModel >> iconName [

	^ nil
]

{ #category : #accessing }
StBasePackageModel >> name [

	self subclassResponsibility
]
