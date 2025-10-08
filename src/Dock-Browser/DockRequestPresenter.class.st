Class {
	#name : 'DockRequestPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textPresenter',
		'acceptPresenter',
		'cancelPresenter',
		'ok',
		'labelPresenter'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
DockRequestPresenter class >> defaultAcceptLabel [

	^ 'Accept'
]

{ #category : 'accessing' }
DockRequestPresenter class >> defaultCancelLabel [

	^ 'Cancel'
]

{ #category : 'accessing' }
DockRequestPresenter >> acceptLabel: aString [

	acceptPresenter label: aString
]

{ #category : 'accessing' }
DockRequestPresenter >> cancelLabel: aString [

	cancelPresenter label: aString
]

{ #category : 'layout' }
DockRequestPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: labelPresenter expand: false;
		add: textPresenter expand: false;
		add: (SpBoxLayout newHorizontal
			beHomogeneous;
			add: cancelPresenter;
			add: acceptPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
DockRequestPresenter >> initialize [

	super initialize.
	ok := false
]

{ #category : 'initialization' }
DockRequestPresenter >> initializeButtons [

	acceptPresenter := self newButton
		label: self class defaultAcceptLabel;
		addStyle: 'suggested-action';
		action: [ 
			self saveThen: [ 
				ok := true. 
				self withPopoverDo: #dismiss ] ].
				
	cancelPresenter := self newButton
		label: self class defaultCancelLabel;
		action: [
			self withPopoverDo: #dismiss ]
]

{ #category : 'initialization' }
DockRequestPresenter >> initializePresenters [
	
	self addStyle: 'dockDialog'.
	
	self initializeButtons.
	labelPresenter := self newLabel.
	textPresenter := self newTextInput
]

{ #category : 'testing' }
DockRequestPresenter >> isOk [

	^ ok
]

{ #category : 'accessing' }
DockRequestPresenter >> label: aString [

	labelPresenter label: aString
]

{ #category : 'private' }
DockRequestPresenter >> saveThen: aBlock [

	aBlock value
]

{ #category : 'accessing' }
DockRequestPresenter >> text [

	^ textPresenter text
]

{ #category : 'accessing' }
DockRequestPresenter >> text: astring [

	^ textPresenter text: astring
]
