Class {
	#name : #PvCompositeIcon,
	#superclass : #Object,
	#instVars : [
		'overlays',
		'name'
	],
	#category : #'Perspective-Icon'
}

{ #category : #'instance creation' }
PvCompositeIcon class >> newName: aName [

	^ self new 
		name: aName;
		yourself
]

{ #category : #'accessing - overlays' }
PvCompositeIcon >> addClass [

	self topLeft: 'overlayClass'
]

{ #category : #'accessing - overlays' }
PvCompositeIcon >> addDirty [

	self bottomRight: #overlayDirty
]

{ #category : #'accessing - overlays' }
PvCompositeIcon >> addNew [

	self bottomRight: 'new'
]

{ #category : #private }
PvCompositeIcon >> addOverlayTo: icon position: position icon: otherIcon [

	position = #topLeft 		ifTrue: [ ^ icon mergeWith: otherIcon ].
	position = #topRight 		ifTrue: [ ^ icon mergeTopRightWith: otherIcon ].	
	position = #bottomLeft 	ifTrue: [ ^ icon mergeBottomLeftWith: otherIcon ].
	position = #bottomRight 	ifTrue: [ ^ icon mergeBottomRightWith: otherIcon ].	
	
	self error: 'Should not arrive here'
]

{ #category : #accessing }
PvCompositeIcon >> bottomLeft: aName [

	overlays at: #bottomLeft put: aName
]

{ #category : #accessing }
PvCompositeIcon >> bottomRight: aName [

	overlays at: #bottomRight put: aName
]

{ #category : #building }
PvCompositeIcon >> buildOn: anApplication [
	| icon |

	icon := anApplication iconNamed: self name.
	overlays keysAndValuesDo: [ :position :iconName | 
		icon := self 
			addOverlayTo: icon 
			position: position 
			icon: (anApplication iconNamed: iconName) ].
		
	^ icon
]

{ #category : #initialization }
PvCompositeIcon >> initialize [

	super initialize.
	overlays := OrderedDictionary new: 2
]

{ #category : #accessing }
PvCompositeIcon >> name [

	^ name
]

{ #category : #accessing }
PvCompositeIcon >> name: aName [

	name := aName
]

{ #category : #accessing }
PvCompositeIcon >> topLeft: aName [

	overlays at: #topLeft put: aName
]

{ #category : #accessing }
PvCompositeIcon >> topRight: aName [

	overlays at: #topRight put: aName
]
