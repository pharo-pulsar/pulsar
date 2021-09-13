Class {
	#name : #StMethodModel,
	#superclass : #Object,
	#instVars : [
		'method'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #'instance creation' }
StMethodModel class >> newMethod: aMethod [ 

	^ self new 
		method: aMethod;
		yourself
]

{ #category : #comparing }
StMethodModel >> = other [

	^ self species = other species 
		and: [ self method = other method ]
]

{ #category : #comparing }
StMethodModel >> hash [

	^ self species hash 
		bitXor: self method hash
]

{ #category : #accessing }
StMethodModel >> iconName [

	^ nil
]

{ #category : #accessing }
StMethodModel >> method [

	^ method
]

{ #category : #accessing }
StMethodModel >> method: anObject [

	method := anObject
]

{ #category : #accessing }
StMethodModel >> name [

	^ self method selector
]

{ #category : #'instance creation' }
StMethodModel >> newEditors [

	^ { StBrowserMethodEditorPresenter on: self }
]

{ #category : #accessing }
StMethodModel >> sourceCode [
	
	^ self method sourceCode
]
