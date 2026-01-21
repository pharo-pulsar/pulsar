"
This view present the list of the traits a class/trait can be composed by.

"
Class {
	#name : 'PulsarClassOutlineTraitSideView',
	#superclass : 'PulsarClassOutlineSideView',
	#instVars : [
		'traitsListPresenter',
		'traitInstanceSidePresenter',
		'traitClassSidePresenter',
		'usersPresenter',
		'usersHeaderPresenter',
		'usersListPresenter',
		'traitsPresenter',
		'traitsHeaderPresenter'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'private' }
PulsarClassOutlineTraitSideView >> collectProtocols [

	^ #()
]

{ #category : 'private' }
PulsarClassOutlineTraitSideView >> collectTraitUsers [

	^ self model collectTraitUsers
]

{ #category : 'private' }
PulsarClassOutlineTraitSideView >> collectVariables [

	^ #()
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> connectPresenters [

	super connectPresenters.
	
	traitsListPresenter outputActivationPort
		transmitDo: [ :anEntity | self entityActivated: anEntity ].
	
	usersListPresenter outputActivationPort
		transmitDo: [ :anEntity | self entityActivated: anEntity ]
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> hideUsersPresenter [

	usersPresenter hide.
	usersListPresenter items: #()
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> initializePresenters [

	super initializePresenters.
	
	self initializeUsersPresenter.
	self initializeTraitsPresenter
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> initializeTraitsPresenter [

	traitsPresenter := self newPresenter.
	
	traitsHeaderPresenter := self instantiate: PulsarEditorToolbarPresenter.
	traitsHeaderPresenter title: 'Traits'.
	
	traitsListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aModel | aModel name ];
		yourself.
		
	traitsPresenter layout: (SpBoxLayout newVertical
		add: traitsHeaderPresenter expand: false;
		add: traitsListPresenter;
		yourself)
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> initializeUsersPresenter [

	usersPresenter := self newPresenter.
	
	usersHeaderPresenter := self instantiate: PulsarEditorToolbarPresenter.
	usersHeaderPresenter title: 'Users'.
	
	usersListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aModel | aModel name ];
		yourself.
		
	usersPresenter layout: (SpBoxLayout newVertical
		add: usersHeaderPresenter expand: false;
		add: usersListPresenter;
		yourself).
		
	usersPresenter hide
]

{ #category : 'private' }
PulsarClassOutlineTraitSideView >> methodsForProtocol: aProtocolModel [

	^ #()
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> updatePresenter [

	self model ifNil: [ ^ self ].

	super updatePresenter.
	
	self model isTrait
		ifTrue: [ self updateUsersPresenter ]
		ifFalse: [ self hideUsersPresenter ].

	traitsListPresenter items: self model traits
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> updateUsersPresenter [

	usersPresenter show.
	usersListPresenter items: self collectTraitUsers
]

{ #category : 'layout' }
PulsarClassOutlineTraitSideView >> verticalLayout [

	^ SpPanedLayout newVertical
		add: usersPresenter;
		add: traitsPresenter;
		yourself
]
