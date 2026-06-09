Class {
	#name : 'PulsarMethodRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'namePresenter',
		'actionPresenter',
		'startLayout',
		'endLayout',
		'actionBlock',
		'usingIcon'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'accessing' }
PulsarMethodRow >> action: aBlock [
	
	actionBlock := aBlock
]

{ #category : 'layout' }
PulsarMethodRow >> actionAtEndLayout [

	^ endLayout ifNil: [ 
		endLayout := SpBoxLayout newHorizontal
			add: namePresenter;
			add: actionPresenter expand: false;
			yourself ]
]

{ #category : 'layout' }
PulsarMethodRow >> actionAtStartLayout [

	^ startLayout ifNil: [ 
		startLayout := SpBoxLayout newHorizontal
			hAlignStart;
			add: actionPresenter expand: false;
			add: namePresenter;
			yourself ]
]

{ #category : 'private' }
PulsarMethodRow >> currentPanelArea [

	^ self withPanelWidgetDo: [ :w | w panelPosition area ]
]

{ #category : 'layout' }
PulsarMethodRow >> defaultLayout [

	^ self isCurrentPanelAreaStart 
		ifTrue: [ self actionAtEndLayout ]
		ifFalse: [ self actionAtStartLayout ]
]

{ #category : 'private' }
PulsarMethodRow >> doAction [

	actionBlock ifNil: [ ^ self ].
	actionBlock cull: self
]

{ #category : 'private' }
PulsarMethodRow >> iconAtEnd [

	^ 'chevron-right'
]

{ #category : 'private' }
PulsarMethodRow >> iconAtStart [

	^ 'chevron-left'
]

{ #category : 'initialization' }
PulsarMethodRow >> initializePresenters [

	self addStyle: 'stRow'.
	self addStyle: 'pulsarMethodRow'.
	actionPresenter := self newButton
		addStyle: 'flat';
		addStyle: 'small';
		addStyle: 'action';
		icon: (self iconNamed: 'chevron-left');
		help: 'Toggle method popover';
		action: [ self doAction ];
		yourself.
		
	namePresenter := self newLabel
]

{ #category : 'private' }
PulsarMethodRow >> isCurrentPanelAreaStart [

	^ self currentPanelArea = SpPanelArea start
]

{ #category : 'initialization' }
PulsarMethodRow >> updateLayoutIfNeeded [

	"yes, this is inversed because the name is where the action is"
	self isCurrentPanelAreaStart 
		ifTrue: [ self useEndLayout ]
		ifFalse: [ self useStartLayout ]
]

{ #category : 'initialization' }
PulsarMethodRow >> updatePresenter [

	self model ifNil: [ ^ self ].
		
	self application defer: [
	
		self updateLayoutIfNeeded.
	
		actionPresenter icon: (self iconNamed: self usingIcon).
	
		namePresenter label: self model name.
		namePresenter removeAllStyles.
		self model decorators
			reject: [ :each | each style isNil ]
			thenDo: [ :each | namePresenter addStyle: each style ] ]
]

{ #category : 'initialization' }
PulsarMethodRow >> useEndLayout [
	
	"skip if already there"
	self layout == self actionAtEndLayout ifTrue: [ ^ self ].
	
	self layout: self actionAtEndLayout.
	usingIcon := self iconAtEnd
]

{ #category : 'initialization' }
PulsarMethodRow >> useStartLayout [
	
	"skip if already there"
	self layout == self actionAtStartLayout ifTrue: [ ^ self ].
	
	self layout: self actionAtStartLayout.
	usingIcon := self iconAtStart
]

{ #category : 'private' }
PulsarMethodRow >> usingIcon [

	^ usingIcon ifNil: [ 
		usingIcon := self isCurrentPanelAreaStart 
			ifTrue: [ self iconAtEnd ]
			ifFalse: [ self iconAtStart ] ]
]
