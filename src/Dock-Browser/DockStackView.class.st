Class {
	#name : 'DockStackView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Browser-View-Stack',
	#package : 'Dock-Browser',
	#tag : 'View-Stack'
}

{ #category : 'defaults' }
DockStackView class >> defaultDockPosition [

	^ DockPanelPosition new 
		area: DockArea start;
		row: 2;
		yourself
]

{ #category : 'layout' }
DockStackView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'events' }
DockStackView >> eventEditorActivated: anAnnouncement [
	| currentItem |
	
	currentItem := listPresenter items
		detect: [ :each | each = anAnnouncement value model ]
		ifNone: [ nil ].
		
	currentItem ifNotNil: [ 
		listPresenter selectItem: currentItem. 
		^ self].

	self updatePresenter.
	listPresenter selectItem: anAnnouncement value model
]

{ #category : 'events' }
DockStackView >> eventEditorClosed: anAnnouncement [
	
	"this just has sense if this is the last one, because all the others will be 
	 processed when autoselect the next editor"
	"listPresenter items size > 1 ifTrue: [ ^ self ]."
	self updatePresenter
]

{ #category : 'events' }
DockStackView >> eventModelChanged: anAnnouncement [
	| currentItems |
	
	anAnnouncement value fullName = anAnnouncement oldEntity fullName ifTrue: [ ^ self ].
	
	self updatePresenter
]

{ #category : 'initialization' }
DockStackView >> initializePresenters [

	toolbarPresenter := self instantiate: DockToolbarPresenter.
	listPresenter := self newEasyListView
		addStyle: 'stList';
		rowPresenterClass: DockStackRow;
		yourself
]

{ #category : 'initialization' }
DockStackView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Editor Stack'
]

{ #category : 'initialization' }
DockStackView >> registerToEvents [

	self announcer 
		when: DockEditorActivated send: #eventEditorActivated: to: self;
		when: DockEditorClosed send: #eventEditorClosed: to: self;
		when: DockModelChanged send: #eventModelChanged: to: self
]

{ #category : 'initialization' }
DockStackView >> updatePresenter [

	self window ifNil: [ ^ self ].

	listPresenter updateItemsKeepingSelection: (self window editors 
		collect: [ :each | each presenter model ]) reversed
]
