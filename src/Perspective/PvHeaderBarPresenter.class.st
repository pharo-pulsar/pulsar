Class {
	#name : 'PvHeaderBarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbarPresenter',
		'toolbarActions'
	],
	#category : 'Perspective-View',
	#package : 'Perspective',
	#tag : 'View'
}

{ #category : 'layout' }
PvHeaderBarPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		vAlignCenter;
		add: toolbarPresenter expand: false;
		yourself
]

{ #category : 'initialization' }
PvHeaderBarPresenter >> initializePresenters [

	toolbarPresenter := self newToolbar
		addStyle: 'pvHeaderBarToolbar';
		displayMode: self application toolbarDisplayMode;
		yourself.
		
	self addStyle: 'pvHeaderBar'
]

{ #category : 'accessing' }
PvHeaderBarPresenter >> toolbarActions [

	^ toolbarActions
]

{ #category : 'accessing' }
PvHeaderBarPresenter >> toolbarActions: anActionGroup [

	toolbarActions := anActionGroup.
	self updatePresenter
]

{ #category : 'initialization' }
PvHeaderBarPresenter >> updatePresenter [

	toolbarPresenter removeAllItems.
	toolbarActions ifNotNil: [ :group |
		toolbarPresenter fillWith: group ]
]
