Class {
	#name : #StBasePackageModel,
	#superclass : #StBaseModel,
	#category : #'NewTools-Browser-Model-Package'
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
StBasePackageModel >> colorName [

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

{ #category : #accessing }
StBasePackageModel >> package [
	
	^ self subclassResponsibility
]
