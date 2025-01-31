Class {
	#name : 'DockSpotterSearchContext',
	#superclass : 'Object',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'instance creation' }
DockSpotterSearchContext class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'accessing' }
DockSpotterSearchContext class >> searchEditors [

	^ DockSpotterSearchEditorsContext uniqueInstance
]

{ #category : 'as yet unclassified' }
DockSpotterSearchContext class >> searchEnvironment [

	^ DockSpotterSearchEnvironmentContext uniqueInstance
]

{ #category : 'as yet unclassified' }
DockSpotterSearchContext class >> searchTools [

	^ DockSpotterSearchToolsContext uniqueInstance
]

{ #category : 'instance creation' }
DockSpotterSearchContext class >> uniqueInstance [

	self = DockSpotterSearchContext 
		ifTrue: [ self error: 'I''m an abstract class, use one of my children instead' ].
	^ uniqueInstance ifNil: [ self basicNew initialize ]
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
DockSpotterSearchContext >> searchPlaceholder [

	^ self subclassResponsibility
]
