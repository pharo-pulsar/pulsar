Class {
	#name : 'PulsarRequestPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'textPresenter',
		'acceptPresenter',
		'cancelPresenter',
		'ok',
		'labelPresenter'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
PulsarRequestPresenter class >> defaultAcceptLabel [

	^ 'Accept'
]

{ #category : 'accessing' }
PulsarRequestPresenter class >> defaultCancelLabel [

	^ 'Cancel'
]

{ #category : 'accessing' }
PulsarRequestPresenter >> acceptLabel: aString [

	acceptPresenter label: aString
]

{ #category : 'accessing' }
PulsarRequestPresenter >> cancelLabel: aString [

	cancelPresenter label: aString
]

{ #category : 'layout' }
PulsarRequestPresenter >> defaultLayout [

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
PulsarRequestPresenter >> initialize [

	super initialize.
	ok := false
]

{ #category : 'initialization' }
PulsarRequestPresenter >> initializeButtons [

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
PulsarRequestPresenter >> initializePresenters [
	
	self addStyle: 'dockDialog'.
	
	self initializeButtons.
	labelPresenter := self newLabel.
	textPresenter := self newTextInput
]

{ #category : 'testing' }
PulsarRequestPresenter >> isOk [

	^ ok
]

{ #category : 'accessing' }
PulsarRequestPresenter >> label: aString [

	labelPresenter label: aString
]

{ #category : 'private' }
PulsarRequestPresenter >> saveThen: aBlock [

	aBlock value
]

{ #category : 'accessing' }
PulsarRequestPresenter >> text [

	^ textPresenter text
]

{ #category : 'accessing' }
PulsarRequestPresenter >> text: astring [

	^ textPresenter text: astring
]
