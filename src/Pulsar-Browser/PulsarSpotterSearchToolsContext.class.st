Class {
	#name : 'PulsarSpotterSearchToolsContext',
	#superclass : 'PulsarSpotterSearchContext',
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
PulsarSpotterSearchToolsContext >> associatedProcessors [

	^ { PvWorldMenuProcessor }
]

{ #category : 'accessing' }
PulsarSpotterSearchToolsContext >> searchPlaceholder [

	^ 'Search for system tools...'
]
