Class {
	#name : 'DockSpotterSearchContext',
	#superclass : 'Object',
	#instVars : [
		'spotter',
		'browser'
	],
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'accessing' }
DockSpotterSearchContext class >> searchEditors [

	^ DockSpotterSearchEditorsContext new
]

{ #category : 'private' }
DockSpotterSearchContext class >> searchEnvironment [

	^ DockSpotterSearchEnvironmentContext new
]

{ #category : 'as yet unclassified' }
DockSpotterSearchContext class >> searchTools [

	^ DockSpotterSearchToolsContext new
]

{ #category : 'visiting' }
DockSpotterSearchContext >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'accessing' }
DockSpotterSearchContext >> associatedProcessors [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
DockSpotterSearchContext >> browser [

	^ browser
]

{ #category : 'accessing' }
DockSpotterSearchContext >> browser: aDockBrowser [

	browser := aDockBrowser
]

{ #category : 'accessing' }
DockSpotterSearchContext >> searchPlaceholder [

	^ self subclassResponsibility
]
