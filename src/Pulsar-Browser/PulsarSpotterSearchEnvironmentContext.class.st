Class {
	#name : 'PulsarSpotterSearchEnvironmentContext',
	#superclass : 'PulsarSpotterSearchContext',
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
PulsarSpotterSearchEnvironmentContext >> associatedProcessors [

	^ { PvUnifiedProcessor }
]

{ #category : 'accessing' }
PulsarSpotterSearchEnvironmentContext >> searchPlaceholder [

	^ 'Search for classes, methods, packages...'
]
