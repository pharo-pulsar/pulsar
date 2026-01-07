Class {
	#name : 'PulsarEditableListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbarPresenter',
		'listPresenter'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'layout' }
PulsarEditableListPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarEditableListPresenter >> initializePresenters [

	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter contentActions: self toolbarActions. 
	listPresenter := self newEasyListView
		addStyle: 'stList';
		yourself
]

{ #category : 'accessing' }
PulsarEditableListPresenter >> items: aCollection [

	listPresenter items: aCollection
]

{ #category : 'accessing' }
PulsarEditableListPresenter >> title: aString [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: aString ]
]

{ #category : 'initialization' }
PulsarEditableListPresenter >> toolbarActions [

	^ SpActionGroup new 
		addActionWith: [ :action | action 
			name: 'Add';
			description: 'Add a new element';
			iconName: #add;
			action: [ self doAdd ] ];
		yourself
]
