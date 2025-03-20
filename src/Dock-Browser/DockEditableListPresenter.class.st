Class {
	#name : 'DockEditableListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbarPresenter',
		'listPresenter'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'layout' }
DockEditableListPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockEditableListPresenter >> initializePresenters [

	toolbarPresenter := self instantiate: DockEditorToolbarPresenter.
	toolbarPresenter contentActions: self toolbarActions. 
	listPresenter := self newEasyListView
		addStyle: 'stList';
		yourself
]

{ #category : 'accessing' }
DockEditableListPresenter >> items: aCollection [

	listPresenter items: aCollection
]

{ #category : 'accessing' }
DockEditableListPresenter >> title: aString [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: aString ]
]

{ #category : 'initialization' }
DockEditableListPresenter >> toolbarActions [

	^ SpActionGroup new 
		addActionWith: [ :action | action 
			name: 'Add';
			description: 'Add a new element';
			iconName: #add;
			action: [ self doAdd ] ];
		yourself
]
