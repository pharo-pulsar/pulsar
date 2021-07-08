Class {
	#name : #StEnvironmentModel,
	#superclass : #Object,
	#instVars : [
		'browserEnvironment'
	],
	#category : #'NewTools-Browser'
}

{ #category : #'instance creation' }
StEnvironmentModel class >> on: anEnvironment [

	^ self new 
		browserEnvironment: anEnvironment;
		yourself
]

{ #category : #accessing }
StEnvironmentModel >> browserEnvironment [

	^ browserEnvironment
]

{ #category : #accessing }
StEnvironmentModel >> browserEnvironment: anObject [

	browserEnvironment := anObject
]

{ #category : #'accessing model' }
StEnvironmentModel >> projects [
	
	^ self browserEnvironment projects sorted: #browserPriority ascending, #browserName ascending
]
