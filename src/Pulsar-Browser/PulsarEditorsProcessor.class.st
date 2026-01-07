Class {
	#name : 'PulsarEditorsProcessor',
	#superclass : 'StSpotterProcessor',
	#instVars : [
		'sourceFactory',
		'context',
		'browser'
	],
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'default-settings' }
PulsarEditorsProcessor class >> defaultEnabled [
	
	^ false
]

{ #category : 'instance creation' }
PulsarEditorsProcessor class >> newEnvironment: anEnvironment [

	^ self newSourceFactory: (PvEnvironmentSourceFactory newEnvironment: anEnvironment)
]

{ #category : 'instance creation' }
PulsarEditorsProcessor class >> newSourceFactory: aSourceFactory [

	^ self basicNew 
		sourceFactory: aSourceFactory;
		initialize;
		yourself
]

{ #category : 'accessing' }
PulsarEditorsProcessor class >> title [

	^ 'Editors'
]

{ #category : 'accessing' }
PulsarEditorsProcessor >> browser [

	^ browser
]

{ #category : 'spotter-api' }
PulsarEditorsProcessor >> isRelevantForQuery: categoryQueryPrefix [

	^ true
]

{ #category : 'filtering' }
PulsarEditorsProcessor >> newTextFilteringSource [

	^ (StCollectionIterator on: (self browser editors
			collect: [ :each | PulsarPanelEntry on: each ])) 
		asSubstringFilter
]

{ #category : 'rendering' }
PulsarEditorsProcessor >> prepareFor: aPulsarSpotterContext [

	browser := aPulsarSpotterContext browser
]

{ #category : 'spotter-api' }
PulsarEditorsProcessor >> showForEmptyQuery [

	^ true
]

{ #category : 'accessing' }
PulsarEditorsProcessor >> sourceFactory [

	^ sourceFactory
]

{ #category : 'accessing' }
PulsarEditorsProcessor >> sourceFactory: aSourceFactory [

	sourceFactory := aSourceFactory
]
