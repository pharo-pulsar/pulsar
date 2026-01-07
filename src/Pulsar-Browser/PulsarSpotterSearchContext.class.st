Class {
	#name : 'PulsarSpotterSearchContext',
	#superclass : 'Object',
	#instVars : [
		'spotter',
		'browser'
	],
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
PulsarSpotterSearchContext class >> searchEditors [

	^ PulsarSpotterSearchEditorsContext new
]

{ #category : 'private' }
PulsarSpotterSearchContext class >> searchEnvironment [

	^ PulsarSpotterSearchEnvironmentContext new
]

{ #category : 'as yet unclassified' }
PulsarSpotterSearchContext class >> searchTools [

	^ PulsarSpotterSearchToolsContext new
]

{ #category : 'visiting' }
PulsarSpotterSearchContext >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'accessing' }
PulsarSpotterSearchContext >> associatedProcessors [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
PulsarSpotterSearchContext >> browser [

	^ browser
]

{ #category : 'accessing' }
PulsarSpotterSearchContext >> browser: aPulsarBrowser [

	browser := aPulsarBrowser
]

{ #category : 'accessing' }
PulsarSpotterSearchContext >> searchPlaceholder [

	^ self subclassResponsibility
]
