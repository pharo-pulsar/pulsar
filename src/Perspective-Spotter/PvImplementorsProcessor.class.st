Class {
	#name : 'PvImplementorsProcessor',
	#superclass : 'StSpotterProcessor',
	#traits : 'PvTSourceFactory',
	#classTraits : 'PvTSourceFactory classTrait',
	#instVars : [
		'label'
	],
	#category : 'Perspective-Spotter-Model-Processor',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Processor'
}

{ #category : 'default-settings' }
PvImplementorsProcessor class >> defaultEnabled [

	^ false
]

{ #category : 'settings' }
PvImplementorsProcessor class >> hideInSettings [

	"I am hidden because the implementation in the unified processor is richer"
	^ true
]

{ #category : 'accessing' }
PvImplementorsProcessor class >> order [
	
	^ 100
]

{ #category : 'accessing' }
PvImplementorsProcessor class >> title [

	^ 'Implementors'
]

{ #category : 'accessing' }
PvImplementorsProcessor >> label [

	^ label
]

{ #category : 'accessing' }
PvImplementorsProcessor >> label: anObject [

	label := anObject
]

{ #category : 'filtering' }
PvImplementorsProcessor >> newTextFilteringSource [

	^ self sourceFactory implementorsSubstringSource
]

{ #category : 'accessing' }
PvImplementorsProcessor >> title [

	^ 'Implementors in {1}' format: { self label }
]
