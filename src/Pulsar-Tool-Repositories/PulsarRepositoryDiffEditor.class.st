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
	#category : 'Pulsar-Tool-Repositories-View-Editor',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> commitToString: aCommitOrWorkingCopy [
	| commitString |
	
	aCommitOrWorkingCopy ifNil: [ ^ '<b>UNKNOWN</b>' ].
	
	aCommitOrWorkingCopy isWorkingCopy ifTrue: [ ^ '<b>Working Copy</b>' ].
		
	^ String streamContents: [ :stream | 
		stream << aCommitOrWorkingCopy shortId.
		
		(aCommitOrWorkingCopy repository headCommit = aCommitOrWorkingCopy) 
			ifTrue: [ stream << ' <b>HEAD</b>' ].

		aCommitOrWorkingCopy tags ifNotEmpty: [ :tags | 
			stream << ' '.
			tags 
				do: [ :each | stream << '<i>' << each name << '</i>' ]
				separatedBy: [ stream << ', ' ] ] ]
]

{ #category : 'layout' }
PulsarRepositoryDiffEditor >> defaultLayout [

	^ SpScrollableLayout new 
		child: SpBoxLayout newVertical;
		withoutHScrollbar;
		propagateNaturalHeight: true;
		yourself
]

{ #category : 'events' }
PulsarRepositoryDiffEditor >> eventCommitModelSelected: ann [
	| commitModel |
	
	commitModel := ann value.
	lastDiffNodeModel := nil.
	
	self model: commitModel diffNode
]

{ #category : 'events' }
PulsarRepositoryDiffEditor >> eventDiffModelSelected: ann [
	| diffNodeModel |
	
	diffNodeModel := ann value.
	lastDiffNodeModel = diffNodeModel ifTrue: [ ^ self ].
	
	self model: diffNodeModel
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> initializePresenters [

	super initializePresenters.
	self addStyle: 'diffEditor'
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

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> newDiffHeader [
	| presenter leftLabelPresenter rightLabelPresenter | 
	
	presenter := self newPresenter.
	presenter layout: (SpBoxLayout newHorizontal vAlignCenter).
	
	presenter addStyle: 'pulsarToolbarPanel'.
	
	leftLabelPresenter := self newLabel
		addStyle: 'pill-commit';
		useMarkup;
		label: (self commitToString: self model root fromCommit);
		yourself.
	rightLabelPresenter := self newLabel
		addStyle: 'pill-commit-active';
		useMarkup;
		label: (self commitToString: self model root toCommit);
		yourself.
	
	presenter layout 
		add: leftLabelPresenter;
		add: rightLabelPresenter expand: false.
		
	^ presenter
]

{ #category : 'private - scheduling' }
PulsarRepositoryDiffEditor >> newScheduler [

	^ PulsarWorker new 
		priority: Processor userBackgroundPriority;
		inTool: self class;
		start
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> patchPresenterClass [

	^ PulsarRepositorySideBySidePresenter
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
		when: PulsarDiffNodeModelSelected send: #eventDiffModelSelected: to: self;
		when: PulsarRepositoryCommitModelSelected send: #eventCommitModelSelected: to: self
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> updatePatchContents [
	| contents nodes groups |
	
	nodes := Array streamContents: [ :stream |
		self model withAllChildrenDo: [ :eachModel | 
			eachModel hasChanges ifTrue: [ 
				stream nextPut: eachModel ] ] ].
				
	contents := SpBoxLayout newVertical vAlignStart. 
	"40 is a magic number"
	groups := nodes groupsOf: 40.
	self withWindowDo: #jobStart.
	contents add: self newDiffHeader.
	groups withIndexDo: [ :eachGroup :index  |
		self queueTask: [
			[
				eachGroup do: [ :eachModel |
					| patchPresenter |
					patchPresenter := self 
						instantiate: self patchPresenterClass 
						on: eachModel.
					self application defer: [ 
						contents add: patchPresenter ] ] ] 
			ensure: [ 
				index = groups size 
					ifTrue: [ self withWindowDo: #jobEnd ] ] ] ].

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
	self purgeTaskWorker.
	taskWorker := nil
]
