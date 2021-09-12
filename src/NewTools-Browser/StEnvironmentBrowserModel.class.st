Class {
	#name : #StEnvironmentBrowserModel,
	#superclass : #Object,
	#instVars : [
		'browserEnvironment'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #'instance creation' }
StEnvironmentBrowserModel class >> on: anEnvironment [

	^ self new 
		browserEnvironment: anEnvironment;
		yourself
]

{ #category : #'accessing model' }
StEnvironmentBrowserModel >> baselines [
	
	self halt.
	^ self browserEnvironment baselines 
		sorted: #browserPriority ascending, #browserName ascending
]

{ #category : #accessing }
StEnvironmentBrowserModel >> browserEnvironment [

	^ browserEnvironment
]

{ #category : #accessing }
StEnvironmentBrowserModel >> browserEnvironment: anObject [

	browserEnvironment := anObject
]

{ #category : #accessing }
StEnvironmentBrowserModel >> packages [
	
	^ (self browserEnvironment packages 
		collect: [ :each | StPackageModel newPackage: each ])
		sorted: #name ascending
]
