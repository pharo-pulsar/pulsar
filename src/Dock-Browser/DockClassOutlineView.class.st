Class {
	#name : 'DockClassOutlineView',
	#superclass : 'DockBaseView',
	#instVars : [
		'toolbarPresenter',
		'structureTreePresenter',
		'instanceSidePresenter',
		'classSidePresenter'
	],
	#category : 'Dock-Browser-ClassOutline',
	#package : 'Dock-Browser',
	#tag : 'ClassOutline'
}

{ #category : 'defaults' }
DockClassOutlineView class >> defaultDockPosition [

	^ DockPosition new
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
		when: DockEditorActivated
		send: #eventEditorActivated: 
		to: self
]

{ #category : 'initialization' }
DockClassOutlineView >> updatePresenter [

	classSidePresenter model: self model.
	instanceSidePresenter model: self model
]

{ #category : 'events' }
DockClassOutlineView >> visitClassModel: aModel [
]

{ #category : 'events' }
DockClassOutlineView >> visitMethodModel: aModel [

	{ instanceSidePresenter. classSidePresenter } do: [ :each | 
		each visitMethodModel: aModel ]
]
