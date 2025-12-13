Class {
	#name : 'DockRepositoryDiffEditor',
	#superclass : 'DockBaseView',
	#traits : 'DockTPanelWindow + DockTScheduling',
	#classTraits : 'DockTPanelWindow classTrait + DockTScheduling classTrait',
	#instVars : [
		'toolbarPresenter',
		'lastDiffNodeModel',
		'mutex'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'layout' }
DockRepositoryDiffEditor >> defaultLayout [

	^ SpScrollableLayout new 
		child: SpBoxLayout newVertical;
		withoutHScrollbar;
		propagateNaturalHeight: true;
		yourself
]

{ #category : 'events' }
DockRepositoryDiffEditor >> eventModelSelected: ann [
	| diffNodeModel |
	
	diffNodeModel := ann value.
	lastDiffNodeModel = diffNodeModel ifTrue: [ ^ self ].
	
	self model: diffNodeModel
]

{ #category : 'initialization' }
DockRepositoryDiffEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Diff';
		whenClosedDo: [ self windowClosed ]
]

{ #category : 'private' }
DockRepositoryDiffEditor >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private - scheduling' }
DockRepositoryDiffEditor >> newScheduler [

	^ DockWorker new 
		priority: Processor userBackgroundPriority;
		inTool: self class;
		start
]

{ #category : 'private' }
DockRepositoryDiffEditor >> purgeTask [

	self scheduler purge.
	[ self scheduler currentTaskExecution ifNotNil: #cancel ]
	on: Error do: [ :e | 
		logger info: 'Task was already cancelled but we do not care.' ]
]

{ #category : 'initialization' }
DockRepositoryDiffEditor >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: DockModelSelected
		send: #eventModelSelected:
		to: self	
]

{ #category : 'initialization' }
DockRepositoryDiffEditor >> updatePatchContents [
	| contents nodes |

	nodes := Array streamContents: [ :stream |
		self model withAllChildrenDo: [ :eachModel | 
			eachModel hasChanges ifTrue: [ 
				stream nextPut: eachModel ] ] ].
		
	contents := SpBoxLayout newVertical vAlignStart.

	(nodes groupsOf: 40) do: [ :eachGroup | 
		self schedule: [
			self withWindowDo: #jobStart.
			[ 
				eachGroup do: [ :eachModel |
					| patchPresenter |	
					patchPresenter := (self instantiate: DockRepositoryPatchPresenter on: eachModel).
					self application defer: [
						contents add: patchPresenter ] ] ]
			ensure: [ self withWindowDo: #jobEnd ] ] ].
		
	self application defer: [
		self layout child: (self newPresenter 
			layout: contents;
			yourself) ] 

]

{ #category : 'initialization' }
DockRepositoryDiffEditor >> updatePresenter [
	| contents |
	
	self model ifNil: [ ^ self ].
	
	lastDiffNodeModel = self model ifNil: [ ^ self ].
	lastDiffNodeModel := self model.
	
	self mutex critical: [
		self purgeTask.
		"since large repositories (e.g. pharo itself) can have a lot of changes when working 
		 on an outdated branch, we skip the diff for the root, as calculate this will take a 
		 lot of time without giving real value to the user."
		self model isRoot 
			ifTrue: [ ^ self updateRootContents ].

		self schedule: [
			self updatePatchContents ] ]
]

{ #category : 'initialization' }
DockRepositoryDiffEditor >> updateRootContents [

	self layout child: (self newPresenter 
		layout: (SpBoxLayout newVertical 
			vAlignStart;
			add: (self newLabel 
				label: 'Please select a node of the diff tree';
				yourself);
			yourself);
		yourself)
	
]

{ #category : 'private' }
DockRepositoryDiffEditor >> windowClosed [

	scheduler ifNil: [ ^ self ].
	self purgeTask.
	self scheduler stop.
	scheduler := nil
]
