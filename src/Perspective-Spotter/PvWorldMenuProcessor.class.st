Class {
	#name : 'PvWorldMenuProcessor',
	#superclass : 'StSpotterProcessor',
	#instVars : [
		'sourceFactory',
		'browser'
	],
	#category : 'Perspective-Spotter-Model-Processor',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Processor'
}

{ #category : 'default-settings' }
PvWorldMenuProcessor class >> defaultEnabled [

	^ true
]

{ #category : 'instance creation' }
PvWorldMenuProcessor class >> newEnvironment: anEnvironment [

	^ self newSourceFactory: (PvEnvironmentSourceFactory newEnvironment: anEnvironment)
]

{ #category : 'instance creation' }
PvWorldMenuProcessor class >> newSourceFactory: aSourceFactory [

	^ self basicNew 
		sourceFactory: aSourceFactory;
		initialize;
		yourself
]

{ #category : 'accessing' }
PvWorldMenuProcessor class >> order [

	^ 150
]

{ #category : 'accessing' }
PvWorldMenuProcessor class >> title [

	^ 'Actions'
]

{ #category : 'accessing' }
PvWorldMenuProcessor >> browser [

	^ browser
]

{ #category : 'filtering' }
PvWorldMenuProcessor >> collectEntriesFrom: aGroup into: aCollection [

	| groupName |
	groupName := aGroup name.
	groupName = CmCommandGroup defaultName ifTrue: [ groupName := nil ].

	aGroup entries do: [ :each |
			each isCommand
				ifTrue: [
						aCollection add: (PulsarCommandEntry new
								 content: each;
								 groupName: groupName;
								 yourself) ]
				ifFalse: [ self collectEntriesFrom: each into: aCollection ] ]
]

{ #category : 'spotter-api' }
PvWorldMenuProcessor >> isRelevantForQuery: categoryQueryPrefix [

	^ true
]

{ #category : 'filtering' }
PvWorldMenuProcessor >> newTextFilteringSource [

	| allEntries |
	allEntries := OrderedCollection new.
	self collectEntriesFrom: self browser globalActions into: allEntries.
	^ (StCollectionIterator on: allEntries) asSubstringFilter
]

{ #category : 'rendering' }
PvWorldMenuProcessor >> prepareFor: aPulsarSpotterContext [

	browser := aPulsarSpotterContext browser
]

{ #category : 'spotter-api' }
PvWorldMenuProcessor >> showForEmptyQuery [

	^ true
]

{ #category : 'accessing' }
PvWorldMenuProcessor >> sourceFactory [

	^ sourceFactory
]

{ #category : 'accessing' }
PvWorldMenuProcessor >> sourceFactory: aSourceFactory [

	sourceFactory := aSourceFactory
]
