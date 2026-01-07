Class {
	#name : 'PulsarSpotterSearchEditorsContext',
	#superclass : 'PulsarSpotterSearchContext',
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
PulsarSpotterSearchEditorsContext >> associatedProcessors [

	^ { PulsarEditorsProcessor }
]

{ #category : 'accessing' }
PulsarSpotterSearchEditorsContext >> searchPlaceholder [

	^ 'Search for open editors...'
]
