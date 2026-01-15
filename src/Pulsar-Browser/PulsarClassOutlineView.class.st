"
A class outline view displays the class structure.


"
Class {
	#name : 'PulsarClassOutlineView',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTTaskWorker + PulsarTSnapshot',
	#classTraits : 'PulsarTTaskWorker classTrait + PulsarTSnapshot classTrait',
	#instVars : [
		'toolbarPresenter',
		'structureTreePresenter',
		'instanceSidePresenter',
		'classSidePresenter',
		'tabLayout',
		'currentActiveSidePresenter',
		'traitSidePresenter'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'defaults' }
PulsarClassOutlineView class >> defaultPanelPosition [

	^ SpPanelPosition endArea
]

{ #category : 'private' }
PulsarClassOutlineView >> classSidePresenter [

	^ classSidePresenter
]

{ #category : 'api - focus' }
PulsarClassOutlineView >> defaultKeyboardFocus [

	^ currentActiveSidePresenter
		ifNil: [ super defaultKeyboardFocus ]
]

{ #category : 'layout' }
PulsarClassOutlineView >> defaultLayout [

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
PulsarClassOutlineView >> eventEditorActivated: anAnnouncement [

	self resetInteractionStatus. "this may be slow, so I schedule it, to not break process..."
	self queueTask: [
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
PulsarClassOutlineView >> eventMethodChanged: aMethodAnnouncement [

	(self model isSameClass: aMethodAnnouncement method methodClass) ifFalse: [ ^ self ].

	logger trace: aMethodAnnouncement.
	self withSidesDo: [ :each | 
		self queueTask: [
			each updateMethods ] ]
]

{ #category : 'events' }
PulsarClassOutlineView >> eventModelChanged: anAnnouncement [
	| changedModel  outlineClassModel |
	
	changedModel := anAnnouncement value.
	
	logger trace: changedModel.
	
	outlineClassModel := changedModel asOutlineClassModel.
	
	(self model = outlineClassModel) ifFalse: [ 
		(anAnnouncement oldEntity isNotNil 
			and: [ anAnnouncement oldEntity isNew ]) 
			ifTrue: [ self model: outlineClassModel ].
		^ self ].
		
	self updatePresenter.
	changedModel accept: self
]

{ #category : 'events' }
PulsarClassOutlineView >> eventTestSuiteEnded: aTestSuiteEnded [

	(self model isTestCase and: [ aTestSuiteEnded testResult classesTested includes: self model entity ]) ifFalse: [ ^ self ].

	logger trace: aTestSuiteEnded.

	self withSidesDo: [ :each | self queueTask: [ each updateMethods ] ]
]

{ #category : 'initialization' }
PulsarClassOutlineView >> initializePresenters [

	toolbarPresenter := self newPulsarToolbar.
	"listPresenter := self newEasyListView 
		addStyle: 'stList';
		display: [ :anEntity | anEntity name ];
		yourself"
		
	instanceSidePresenter := self instantiate: PulsarClassOutlineInstanceSideView.
	classSidePresenter := self instantiate: PulsarClassOutlineClassSideView.
	traitSidePresenter := self instantiate: PulsarClassOutlineTraitSideView
]

{ #category : 'initialization' }
PulsarClassOutlineView >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Outline';
		whenClosedDo: [ self stopScheduler ]
]

{ #category : 'private' }
PulsarClassOutlineView >> instanceSidePresenter [

	^ instanceSidePresenter
]

{ #category : 'private - announcing' }
PulsarClassOutlineView >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private - announcing' }
PulsarClassOutlineView >> notifyEntityChanged: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (PulsarModelChanged newValue: anEntity)
]

{ #category : 'private - announcing' }
PulsarClassOutlineView >> notifyEntityRemoved: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: (PulsarModelRemoved newValue: anEntity)
]

{ #category : 'private - announcing' }
PulsarClassOutlineView >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newSelectionAnnouncement
]

{ #category : 'initialization' }
PulsarClassOutlineView >> registerToEvents [
	
	self registerToSystemEvents.
	
	self announcer 
		when: PulsarEditorActivated send: #eventEditorActivated: to: self;
		when: PulsarModelChanged send: #eventModelChanged: to: self
]

{ #category : 'initialization' }
PulsarClassOutlineView >> registerToSystemEvents [
	
	self announcer
		when: MethodAnnouncement send: #eventMethodChanged: to: self;
		when: TestSuiteEnded send: #eventTestSuiteEnded: to: self
]

{ #category : 'initialization' }
PulsarClassOutlineView >> resetInteractionStatus [
	"reset any status that may be active when interacting with the outline.
	 e.g. active popovers"
	 
	 self withSidesDo: [ :each | each resetInteractionStatus ]
]

{ #category : 'private' }
PulsarClassOutlineView >> tabActivated: aPresenter [

	currentActiveSidePresenter := aPresenter
]

{ #category : 'private' }
PulsarClassOutlineView >> traitSidePresenter [

	^ traitSidePresenter
]

{ #category : 'initialization' }
PulsarClassOutlineView >> updatePresenter [

	logger trace.

	self withSidesDo: [ :each | 
		each model: self model ].
		
	self updateTitle
]

{ #category : 'initialization' }
PulsarClassOutlineView >> updateTitle [

	self withPanelWindowDo: [ :w | 
		w title: self model name ]
]

{ #category : 'events' }
PulsarClassOutlineView >> visitClassModel: aModel [
	
	logger trace: aModel.
	
	self withSidesDo: [ :each | 
		each visitClassModel: aModel ]
]

{ #category : 'events' }
PulsarClassOutlineView >> visitMethodModel: aModel [

	logger trace: aModel.

	self withSidesDo: [ :each |
		(each includesModel: aModel) 
			ifTrue: [ tabLayout select: each ].
		each visitMethodModel: aModel ]
]

{ #category : 'events' }
PulsarClassOutlineView >> visitProjectModel: aModel [

	self visitClassModel: aModel asClassModel
]

{ #category : 'private' }
PulsarClassOutlineView >> withSidesDo: aBlock [

	{ 
		classSidePresenter.
		instanceSidePresenter.
		traitSidePresenter.
	}
	do: [ :each | 
		aBlock value: each ]
]
