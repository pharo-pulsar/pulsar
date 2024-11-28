Class {
	#name : 'DockClassOutlineView',
	#superclass : 'DockBaseView',
	#instVars : [
		'toolbarPresenter',
		'structureTreePresenter',
		'instanceSidePresenter',
		'classSidePresenter'
	],
	#category : 'Dock-Browser-Outline',
	#package : 'Dock-Browser',
	#tag : 'Outline'
}

{ #category : 'defaults' }
DockClassOutlineView class >> defaultDockPosition [

	^ DockPanelPosition new
		area: DockArea end;
		yourself
]

{ #category : 'initialization' }
DockClassOutlineView >> connectPresenters [

	
]

{ #category : 'layout' }
DockClassOutlineView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (SpTabLayout new 
			add: instanceSidePresenter label: 'Instance';
			add: classSidePresenter label: 'Class';
			yourself);
		yourself
]

{ #category : 'events' }
DockClassOutlineView >> eventEditorActivated: anAnnouncement [
	| activatedModel outlineModel |

	activatedModel := anAnnouncement value model.
	outlineModel := activatedModel asOutlineClassModel.
	self model = outlineModel 
		ifFalse: [ self model: outlineModel ].
		
	"visit after to be able to post-process"
	activatedModel accept: self
]

{ #category : 'events' }
DockClassOutlineView >> eventModelChanged: anAnnouncement [
	| changedModel  outlineClassModel |
	
	changedModel := anAnnouncement value.
	outlineClassModel := changedModel asOutlineClassModel.
	self model = outlineClassModel ifFalse: [ ^ self ].
	"update because it may have change"
	self updatePresenter.
	"visit after to be able to post-process"
	changedModel accept: self
]

{ #category : 'initialization' }
DockClassOutlineView >> initializePresenters [

	toolbarPresenter := self newDockToolbar.
	"listPresenter := self newEasyListView 
		addStyle: 'stList';
		display: [ :anEntity | anEntity name ];
		yourself"
		
	instanceSidePresenter := self instantiate: DockClassOutlineInstanceSideView.
	classSidePresenter := self instantiate: DockClassOutlineClassSideView
]

{ #category : 'initialization' }
DockClassOutlineView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Outline'
]

{ #category : 'initialization' }
DockClassOutlineView >> registerToEvents [
	
	self announcer 
		when: DockEditorActivated send: #eventEditorActivated: to: self;
		when: DockModelChanged send: #eventModelChanged: to: self
]

{ #category : 'initialization' }
DockClassOutlineView >> updatePresenter [

	classSidePresenter model: self model.
	instanceSidePresenter model: self model.

	self withPanelWindowDo: [ :w | 
		w title: self model name ]
]

{ #category : 'events' }
DockClassOutlineView >> visitClassModel: aModel [

	{ 
		instanceSidePresenter. 
		classSidePresenter } 
	do: [ :each | 
		each visitClassModel: aModel ]
]

{ #category : 'events' }
DockClassOutlineView >> visitMethodModel: aModel [

	{ 
		instanceSidePresenter. 
		classSidePresenter } 
	do: [ :each | 
		each visitMethodModel: aModel ]
]
