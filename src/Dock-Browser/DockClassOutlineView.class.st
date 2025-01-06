Class {
	#name : 'DockClassOutlineView',
	#superclass : 'DockBaseView',
	#instVars : [
		'toolbarPresenter',
		'structureTreePresenter',
		'instanceSidePresenter',
		'classSidePresenter',
		'tabLayout',
		'currentActiveSidePresenter',
		'traitSidePresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'defaults' }
DockClassOutlineView class >> defaultDockPosition [

	^ DockPanelPosition new
		area: DockArea end;
		yourself
]

{ #category : 'api - focus' }
DockClassOutlineView >> defaultKeyboardFocus [

	^ currentActiveSidePresenter
		ifNil: [ super defaultKeyboardFocus ]
]

{ #category : 'layout' }
DockClassOutlineView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: ((tabLayout := SpTabLayout new)
			add: instanceSidePresenter label: 'Instance';
			add: classSidePresenter label: 'Class';
			add: traitSidePresenter label: 'Traits';
			whenTabSelectedDo: [ :ann | self tabActivated: ann presenter ];
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
	self updatePresenter.
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
	classSidePresenter := self instantiate: DockClassOutlineClassSideView.
	traitSidePresenter := self instantiate: DockClassOutlineTraitSideView
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

{ #category : 'private' }
DockClassOutlineView >> tabActivated: aPresenter [

	currentActiveSidePresenter := aPresenter
]

{ #category : 'initialization' }
DockClassOutlineView >> updatePresenter [

	classSidePresenter model: self model.
	instanceSidePresenter model: self model.

	self updateTitle
]

{ #category : 'initialization' }
DockClassOutlineView >> updateTitle [

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
		(each includesModel: aModel) 
			ifTrue: [ tabLayout select: each ].
		each visitMethodModel: aModel ]
]
