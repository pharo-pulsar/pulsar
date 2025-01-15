Class {
	#name : 'DockEditorUpdateVisitor',
	#superclass : 'SpPresenterVisitor',
	#instVars : [
		'owner'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'instance creation' }
DockEditorUpdateVisitor class >> on: aPresenter [

	^ self new 
		owner: aPresenter;
		yourself
]

{ #category : 'accessing' }
DockEditorUpdateVisitor >> owner [

	^ owner
]

{ #category : 'accessing' }
DockEditorUpdateVisitor >> owner: aPresenter [

	owner := aPresenter
]

{ #category : 'visiting' }
DockEditorUpdateVisitor >> visitPanelWindowPresenter: aPanelWindowPresenter [

	self owner updateTitle
]
