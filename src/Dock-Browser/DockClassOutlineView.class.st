Class {
	#name : 'DockClassOutlineView',
	#superclass : 'DockBaseView',
	#traits : 'DockTScheduling + DockTSnapshot',
	#classTraits : 'DockTScheduling classTrait + DockTSnapshot classTrait',
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

	^ SpPanelPosition new
		area: SpPanelArea end;
		yourself
]

{ #category : 'private' }
DockClassOutlineView >> classSidePresenter [

	^ classSidePresenter
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

	self resetInteractionStatus.
	"this may be slow, so I schedule it, to not break process..."
	self schedule: [ 
		| activatedModel outlineModel |
		
		"editor can be closed in the meantime (concurrency problems... :P).
		 value holds an editor, I can then ask for its window to know if this 
		 is still around."
		anAnnouncement value window isOpen ifTrue: [
			activatedModel := anAnnouncement value model.
			outlineModel := activatedModel asOutlineClassModel.		
			self model = outlineModel ifFalse: [
				logger trace: outlineModel.
				self model: outlineModel ].
			"visit after to be able to post-process"
			activatedModel accept: self ] ]
]

{ #category : 'events' }
DockClassOutlineView >> eventMethodChanged: aMethodAnnouncement [

	(self model isSameClass: aMethodAnnouncement method methodClass)
		ifFalse: [ ^ self ].

	logger trace: aMethodAnnouncement.
	
	self withClassSidesDo: [ :each |
		self schedule: [ each updateMethods ] ]
]

{ #category : 'events' }
DockClassOutlineView >> eventModelChanged: anAnnouncement [
	| changedModel  outlineClassModel |
	
	changedModel := anAnnouncement value.
	
	logger trace: changedModel.
	
	outlineClassModel := changedModel asOutlineClassModel.
	
	(self model = outlineClassModel) ifFalse: [ 
		anAnnouncement oldEntity isNew 
			ifTrue: [ self model: outlineClassModel ].
		^ self ].
		
	self updatePresenter.
	changedModel accept: self
]

{ #category : 'events' }
DockClassOutlineView >> eventTestSuiteEnded: aTestSuiteEnded [

	(self model isTestCase
		and: [ aTestSuiteEnded testResult classesTested includes: self model entity ])
		ifFalse: [ ^ self ].

	logger trace: aTestSuiteEnded.
	
	self withClassSidesDo: [ :each | 
		self schedule: [ each updateMethods ] ] 
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

	aWindowPresenter 
		title: 'Outline';
		whenClosedDo: [ self stopScheduler ]
]

{ #category : 'private' }
DockClassOutlineView >> instanceSidePresenter [

	^ instanceSidePresenter
]

{ #category : 'private - announcing' }
DockClassOutlineView >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private - announcing' }
DockClassOutlineView >> notifyEntityChanged: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelChanged newValue: anEntity)
]

{ #category : 'private - announcing' }
DockClassOutlineView >> notifyEntityRemoved: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (DockModelRemoved newValue: anEntity)
]

{ #category : 'private - announcing' }
DockClassOutlineView >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newSelectionAnnouncement
]

{ #category : 'initialization' }
DockClassOutlineView >> registerToEvents [
	
	self registerToSystemEvents.
	
	self announcer 
		when: DockEditorActivated send: #eventEditorActivated: to: self;
		when: DockModelChanged send: #eventModelChanged: to: self
]

{ #category : 'initialization' }
DockClassOutlineView >> registerToSystemEvents [
	
	self announcer
		when: MethodAnnouncement send: #eventMethodChanged: to: self;
		when: TestSuiteEnded send: #eventTestSuiteEnded: to: self
]

{ #category : 'initialization' }
DockClassOutlineView >> resetInteractionStatus [
	"reset any status that may be active when interacting with the outline.
	 e.g. active popovers"
	 
	 self withClassSidesDo: [ :each | each resetInteractionStatus ]
]

{ #category : 'private' }
DockClassOutlineView >> tabActivated: aPresenter [

	currentActiveSidePresenter := aPresenter
]

{ #category : 'initialization' }
DockClassOutlineView >> updatePresenter [

	logger trace.

	self withClassSidesDo: [ :each | 
		each model: self model ].
	self updateTitle
]

{ #category : 'initialization' }
DockClassOutlineView >> updateTitle [

	self withPanelWindowDo: [ :w | 
		w title: self model name ]
]

{ #category : 'events' }
DockClassOutlineView >> visitClassModel: aModel [
	
	logger trace: aModel.
	
	self withClassSidesDo: [ :each | 
		each visitClassModel: aModel ]
]

{ #category : 'events' }
DockClassOutlineView >> visitMethodModel: aModel [

	logger trace: aModel.

	self withClassSidesDo: [ :each |
		(each includesModel: aModel) 
			ifTrue: [ tabLayout select: each ].
		each visitMethodModel: aModel ]
]

{ #category : 'events' }
DockClassOutlineView >> visitProjectModel: aModel [

	self visitClassModel: aModel asClassModel
]

{ #category : 'private' }
DockClassOutlineView >> withClassSidesDo: aBlock [

	{ 
		classSidePresenter.
		instanceSidePresenter 
	}
	do: [ :each | aBlock value: each ]
]
