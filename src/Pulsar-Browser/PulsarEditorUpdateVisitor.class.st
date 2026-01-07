Class {
	#name : 'PulsarEditorUpdateVisitor',
	#superclass : 'SpPresenterVisitor',
	#instVars : [
		'owner'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'instance creation' }
PulsarEditorUpdateVisitor class >> on: aPresenter [

	^ self new 
		owner: aPresenter;
		yourself
]

{ #category : 'accessing' }
PulsarEditorUpdateVisitor >> owner [

	^ owner
]

{ #category : 'accessing' }
PulsarEditorUpdateVisitor >> owner: aPresenter [

	owner := aPresenter
]

{ #category : 'visiting' }
PulsarEditorUpdateVisitor >> visitPanelWindowPresenter: aPanelWindowPresenter [

	self owner updatePanelWindowTitle
]

{ #category : 'visiting' }
PulsarEditorUpdateVisitor >> visitPopoverPresenter: aPresenter [
	
]
