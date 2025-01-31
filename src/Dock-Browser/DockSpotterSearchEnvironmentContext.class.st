Class {
	#name : 'DockSpotterSearchEnvironmentContext',
	#superclass : 'DockSpotterSearchContext',
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
DockSpotterSearchEnvironmentContext >> associatedProcessors [

	^ { PvUnifiedProcessor }
]

{ #category : 'accessing' }
DockSpotterSearchEnvironmentContext >> searchPlaceholder [

	^ 'Search for classes, methods, packages...'
]
