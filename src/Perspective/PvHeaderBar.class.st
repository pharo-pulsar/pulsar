Class {
	#name : #PvHeaderBar,
	#superclass : #SpPresenter,
	#instVars : [
		'toolbar'
	],
	#category : #'Perspective-View'
}

{ #category : #layout }
PvHeaderBar >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		vAlignCenter;
		add: toolbar expand: false;
		yourself
]

{ #category : #initialization }
PvHeaderBar >> initializePresenters [

	toolbar := self newToolbar
		addStyle: 'pvHeaderBarToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself.
		
	self addStyle: 'pvHeaderBar'
]
