Class {
	#name : 'DockSpotterSearchToolsContext',
	#superclass : 'DockSpotterSearchContext',
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
DockSpotterSearchToolsContext >> associatedProcessors [

	^ { PvWorldMenuProcessor }
]

{ #category : 'accessing' }
DockSpotterSearchToolsContext >> searchPlaceholder [

	^ 'Search for system tools...'
]
