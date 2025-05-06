Class {
	#name : 'DockContextStackPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'listPresenter'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'layout' }
DockContextStackPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockContextStackPresenter >> initializePresenters [

	listPresenter := self newEasyListView
]
