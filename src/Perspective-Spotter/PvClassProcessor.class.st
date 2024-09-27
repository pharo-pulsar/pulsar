Class {
	#name : 'PvClassProcessor',
	#superclass : 'StSpotterProcessor',
	#traits : 'PvTSourceFactory',
	#classTraits : 'PvTSourceFactory classTrait',
	#instVars : [
		'label',
		'wantsToDisplayOnEmptyQuery'
	],
	#category : 'Perspective-Spotter-Model-Processor',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Processor'
}

{ #category : 'default-settings' }
PvClassProcessor class >> defaultEnabled [

	^ false
]

{ #category : 'settings' }
PvClassProcessor class >> hideInSettings [

	"I am hidden because the implementation in the unified processor is richer"
	^ true
]

{ #category : 'accessing' }
PvClassProcessor class >> order [
	
	^ 100
]

{ #category : 'accessing' }
PvClassProcessor class >> title [

	^ 'Classes'
]

{ #category : 'initialization' }
PvClassProcessor >> initialize [

	super initialize.
	self wantsToDisplayOnEmptyQuery: false
]

{ #category : 'accessing' }
PvClassProcessor >> label [

	^ label
]

{ #category : 'accessing' }
PvClassProcessor >> label: anObject [

	label := anObject
]

{ #category : 'filtering' }
PvClassProcessor >> newTextFilteringSource [

	^ self sourceFactory classesSubstringSource
]

{ #category : 'configuration' }
PvClassProcessor >> showForEmptyQuery [

	^ self wantsToDisplayOnEmptyQuery
]

{ #category : 'accessing' }
PvClassProcessor >> title [

	^ 'Classes in {1}' format: { self label }
]

{ #category : 'accessing' }
PvClassProcessor >> wantsToDisplayOnEmptyQuery [

	^ wantsToDisplayOnEmptyQuery
]

{ #category : 'accessing' }
PvClassProcessor >> wantsToDisplayOnEmptyQuery: aBoolean [

	wantsToDisplayOnEmptyQuery := aBoolean
]
