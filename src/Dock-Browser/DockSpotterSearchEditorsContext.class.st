Class {
	#name : 'DockSpotterSearchEditorsContext',
	#superclass : 'DockSpotterSearchContext',
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
DockSpotterSearchEditorsContext >> associatedProcessors [

	^ { DockEditorsProcessor }
]

{ #category : 'accessing' }
DockSpotterSearchEditorsContext >> searchPlaceholder [

	^ 'Search for open editors...'
]
