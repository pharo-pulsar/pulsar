Class {
	#name : 'PulsarRepositoryDiffEditor',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTPanelWindow + PulsarTTaskWorker',
	#classTraits : 'PulsarTPanelWindow classTrait + PulsarTTaskWorker classTrait',
	#instVars : [
		'toolbarPresenter',
		'lastDiffNodeModel',
		'mutex'
	],
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'layout' }
PulsarRepositoryDiffEditor >> defaultLayout [

	^ SpScrollableLayout new 
		child: SpBoxLayout newVertical;
		withoutHScrollbar;
		propagateNaturalHeight: true;
		yourself
]

{ #category : 'events' }
PulsarRepositoryDiffEditor >> eventModelSelected: ann [
	| diffNodeModel |
	
	diffNodeModel := ann value.
	lastDiffNodeModel = diffNodeModel ifTrue: [ ^ self ].
	
	self model: diffNodeModel
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Diff';
		whenClosedDo: [ self windowClosed ]
]

{ #category : 'private' }
PulsarRepositoryDiffEditor >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private - scheduling' }
PulsarRepositoryDiffEditor >> newScheduler [

	^ PulsarWorker new 
		priority: Processor userBackgroundPriority;
		inTool: self class;
		start
]

{ #category : 'private' }
PulsarRepositoryDiffEditor >> purgeTask [

	self taskWorker purge.
	[ self taskWorker currentTaskExecution ifNotNil: #cancel ]
		on: Error
		do: [ :e | logger info: 'Task was already cancelled but we do not care.' ]
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> registerToEvents [

	super registerToEvents.
	self announcer 
		when: PulsarModelSelected
		send: #eventModelSelected:
		to: self	
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> updatePatchContents [
	| contents nodes |
	
	nodes := Array streamContents: [ :stream |
		self model withAllChildrenDo: [ :eachModel | 
			eachModel hasChanges ifTrue: [ 
				stream nextPut: eachModel ] ] ].

	contents := SpBoxLayout newVertical vAlignStart. 
	"40 is a magic number"
	(nodes groupsOf: 40) do: [ :eachGroup |
		self queueTask: [
			self withWindowDo: #jobStart.
			[
				eachGroup do: [ :eachModel |
					| patchPresenter |
					patchPresenter := self 
						instantiate: PulsarRepositoryPatchPresenter 
						on: eachModel.
					self application defer: [ 
						contents add: patchPresenter ] ] ] 
			ensure: [ 
				self withWindowDo: #jobEnd ] ] ].

	self application defer: [
		self layout child: (self newPresenter
			 layout: contents;
			 yourself) ]
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> updatePresenter [
	| contents |
	
	self model ifNil: [ ^ self ].

	lastDiffNodeModel = self model ifNil: [ ^ self ].
	lastDiffNodeModel := self model.

	self mutex critical: [
		self purgeTask. 
		"since large repositories (e.g. pharo itself) can have a lot of changes when working 
	 	 on an outdated branch, we skip the diff for the root, as calculate this will take a 
	 	 lot of time without giving real value to the user."
		(self model isRoot and: [ self model isBigChange ]) ifTrue: [ ^ self updateRootContents ].
		self queueTask: [ 
			self updatePatchContents ] ]
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> updateRootContents [

	self layout child: (self newPresenter 
		layout: (SpBoxLayout newVertical 
			vAlignStart;
			add: (self newLabel 
				label: 'I can''t display the changes (changeset is too big). Please select a node of the diff tree';
				yourself);
			yourself);
		yourself)
	
]

{ #category : 'private' }
PulsarRepositoryDiffEditor >> windowClosed [

	taskWorker ifNil: [ ^ self ].
	self purgeTask.
	self taskWorker stop.
	taskWorker := nil
]
