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
		'usersListPresenter'
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
	
	usersListPresenter outputActivationPort
		transmitDo: [ :anEntity | self entityActivated: anEntity ]
]

{ #category : 'layout' }
PulsarClassOutlineTraitSideView >> defaultLayout [

	^ SpPanedLayout newVertical
		add: usersPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> hideUsersPresenter [

	usersPresenter hide.
	usersListPresenter items: #()
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> initializePresenters [

	super initializePresenters.
	
	usersPresenter := self newPresenter.
	
	usersHeaderPresenter := self instantiate: PulsarEditorToolbarPresenter.
	usersHeaderPresenter title: 'Users'.
	
	usersListPresenter := self newEasyListView
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
		ifFalse: [ self hideUsersPresenter ]
]

{ #category : 'initialization' }
PulsarClassOutlineTraitSideView >> updateUsersPresenter [

	usersPresenter show.
	usersListPresenter items: self collectTraitUsers
]
