Class {
	#name : 'PulsarIconProxy',
	#superclass : 'Object',
	#instVars : [
		'iconName',
		'iconProvider'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'instance creation' }
PulsarIconProxy class >> name: aSymbol provider: anIconProvider [

	^ self new
		  iconName: aSymbol;
		  iconProvider: anIconProvider;
		  yourself
]

{ #category : 'resolving' }
PulsarIconProxy >> doesNotUnderstand: aMessage [
	| form |
	
	form := iconProvider iconNamed: iconName.
	form ifNil: [ ^ nil ].
	^ aMessage sendTo: form
]

{ #category : 'accessing' }
PulsarIconProxy >> iconName [

	^ iconName
]

{ #category : 'accessing' }
PulsarIconProxy >> iconName: aSymbol [

	iconName := aSymbol
]

{ #category : 'accessing' }
PulsarIconProxy >> iconProvider [

	^ iconProvider
]

{ #category : 'accessing' }
PulsarIconProxy >> iconProvider: anIconProvider [

	iconProvider := anIconProvider
]
