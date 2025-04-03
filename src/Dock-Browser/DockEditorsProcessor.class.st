Class {
	#name : 'DockEditorsProcessor',
	#superclass : 'StSpotterProcessor',
	#instVars : [
		'sourceFactory',
		'context',
		'browser'
	],
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'default-settings' }
DockEditorsProcessor class >> defaultEnabled [
	
	^ false
]

{ #category : 'instance creation' }
DockEditorsProcessor class >> newEnvironment: anEnvironment [

	^ self newSourceFactory: (PvEnvironmentSourceFactory newEnvironment: anEnvironment)
]

{ #category : 'instance creation' }
DockEditorsProcessor class >> newSourceFactory: aSourceFactory [

	^ self basicNew 
		sourceFactory: aSourceFactory;
		initialize;
		yourself
]

{ #category : 'accessing' }
DockEditorsProcessor class >> title [

	^ 'Editors'
]

{ #category : 'accessing' }
DockEditorsProcessor >> browser [

	^ browser
]

{ #category : 'spotter-api' }
DockEditorsProcessor >> isRelevantForQuery: categoryQueryPrefix [

	^ true
]

{ #category : 'filtering' }
DockEditorsProcessor >> newTextFilteringSource [

	^ (StCollectionIterator on: (self browser editors
			collect: [ :each | DockPanelEntry on: each ])) 
		asSubstringFilter
]

{ #category : 'rendering' }
DockEditorsProcessor >> prepareFor: aDockSpotterContext [

	browser := aDockSpotterContext browser
]

{ #category : 'spotter-api' }
DockEditorsProcessor >> showForEmptyQuery [

	^ true
]

{ #category : 'accessing' }
DockEditorsProcessor >> sourceFactory [

	^ sourceFactory
]

{ #category : 'accessing' }
DockEditorsProcessor >> sourceFactory: aSourceFactory [

	sourceFactory := aSourceFactory
]
