Class {
	#name : #PvOutlineClassModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'modelClass'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Outline'
}

{ #category : #accessing }
PvOutlineClassModel >> children [

	^ self collectClassVariables,
	  self collectVariables, 
	  self collectClassMethods,  
	  self collectMethods
]

{ #category : #private }
PvOutlineClassModel >> collectClassMethods [
	
	^ (self entity classSide methods 
		collect: [ :each | StMethodModel newMethod: each ])
		sorted: #name ascending
]

{ #category : #private }
PvOutlineClassModel >> collectClassVariables [
	
	^ #()
]

{ #category : #private }
PvOutlineClassModel >> collectMethods [
	
	^ (self entity instanceSide methods 
		collect: [ :each | StMethodModel newMethod: each ])
		sorted: #name ascending
]

{ #category : #private }
PvOutlineClassModel >> collectVariables [
	
	^ #()
]

{ #category : #accessing }
PvOutlineClassModel >> modelClass [

	^ modelClass
]

{ #category : #accessing }
PvOutlineClassModel >> modelClass: aClass [

	modelClass := aClass
]

{ #category : #accessing }
PvOutlineClassModel >> name [

	^ self entity name
]
