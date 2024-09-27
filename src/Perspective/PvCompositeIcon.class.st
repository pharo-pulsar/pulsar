Class {
	#name : 'PvCompositeIcon',
	#superclass : 'Object',
	#instVars : [
		'name',
		'decorations'
	],
	#category : 'Perspective-Icon',
	#package : 'Perspective',
	#tag : 'Icon'
}

{ #category : 'instance creation' }
PvCompositeIcon class >> newName: aName [

	^ self new 
		name: aName;
		yourself
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> addAbstract [

	decorations := decorations copyWith: PvGrayIconDecoration new
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> addClass [

	self topLeft: 'overlayClass'
]

{ #category : 'accessing' }
PvCompositeIcon >> addDecoration: aDecorations [

	decorations := decorations copyWith: aDecorations
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> addDirty [

	self bottomRight: 'overlayDirty'
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> addNew [

	self bottomRight: 'new'
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> bottomLeft: aName [

	self addDecoration: (PvOverlayIconDecoration new 
		position: #bottomLeft; 
		overlay: aName;
		yourself)
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> bottomRight: aName [

	self addDecoration: (PvOverlayIconDecoration new 
		position: #bottomRight; 
		overlay: aName;
		yourself)
]

{ #category : 'building' }
PvCompositeIcon >> buildOn: anApplication [
	| icon |

	icon := anApplication iconCache iconAt: self ifAbsent: [ nil ].
	icon ifNotNil: [ ^ icon ].

	icon := anApplication iconNamed: self name.
	decorations do: [ :each | 
		icon :=  each applyTo: icon on: anApplication ].

	anApplication iconCache iconAt: self put: icon.	
		
	^ icon
]

{ #category : 'accessing' }
PvCompositeIcon >> decorations [

	^ decorations
]

{ #category : 'accessing' }
PvCompositeIcon >> fullName [

	self hasDecorations ifFalse: [ ^ self name ].
	
	^ String streamContents: [ :stream |
		stream << self name.
		stream << '_'.
		self decorations 
			do: [ :each | stream << each name ]
			separatedBy: [ stream << '_' ] ]
]

{ #category : 'testing' }
PvCompositeIcon >> hasDecorations [

	^ decorations isNotEmpty
]

{ #category : 'initialization' }
PvCompositeIcon >> initialize [

	super initialize.
	decorations := #()
]

{ #category : 'accessing' }
PvCompositeIcon >> name [

	^ name
]

{ #category : 'accessing' }
PvCompositeIcon >> name: aName [

	name := aName
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> topLeft: aName [

	self addDecoration: (PvOverlayIconDecoration new 
		position: #topLeft; 
		overlay: aName;
		yourself)
]

{ #category : 'accessing - decorations' }
PvCompositeIcon >> topRight: aName [

	self addDecoration: (PvOverlayIconDecoration new 
		position: #topRight; 
		overlay: aName;
		yourself)
]
