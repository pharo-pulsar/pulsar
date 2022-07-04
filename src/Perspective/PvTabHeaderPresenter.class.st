Class {
	#name : #PvTabHeaderPresenter,
	#superclass : #PvHeaderPresenter,
	#instVars : [
		'closeButton'
	],
	#category : #'Perspective-View-Header'
}

{ #category : #initialization }
PvTabHeaderPresenter >> initializePresenters [

	super initializePresenters.
	
	self layout
		addLast: (closeButton := self newButton) expand: false.

	closeButton 
		addStyle: 'flat';
		"addStyle: 'circular';"
		icon:  (self application iconNamed: 'gtk-close');
		action: [ self delete ]
]

{ #category : #accessing }
PvTabHeaderPresenter >> labelPresenter [

	^ titleLabel
]
