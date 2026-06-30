Class {
	#name : 'PulsarRepositoryDiffEditor',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTTaskWorker + PulsarTEditor',
	#classTraits : 'PulsarTTaskWorker classTrait + PulsarTEditor classTrait',
	#instVars : [
		'toolbarPresenter',
		'lastDiffNodeModel',
		'mutex',
		'taskWorker',
		'commitInfoPresenter',
		'scrollableLayoutForContent'
	],
	#category : 'Pulsar-Tool-Repositories-View-Editor',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Editor'
}

{ #category : 'private' }
PulsarRepositoryDiffEditor >> commitForInfo [
	| root commit |
	
	root := self model root.
	root ifNil: [ ^ nil ].

	commit := root toCommitish.
	commit isWorkingCopy ifTrue: [ ^ nil ].
	"yeah, this can happen... and I do not want the branch, I want the branch
	 head commit."
	commit isBranch ifTrue: [ commit := commit commit ].
	
	^ (commit isNotNil and: [ commit isWorkingCopy not ])
		ifTrue: [ commit ]
		ifFalse: [ nil ]
]

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

	^ SpBoxLayout newVertical
		  add: self scrollableLayoutForContent;
		  add: commitInfoPresenter expand: false;
		  yourself
]

{ #category : 'events' }
PulsarRepositoryDiffEditor >> eventCommitModelSelected: ann [
	| commitModel |
	
	commitModel := ann value.
	lastDiffNodeModel := nil.
	
	self model: commitModel diffNode.
	self withPanelWidgetDo: [ :w | w raise ]
]

{ #category : 'events' }
PulsarRepositoryDiffEditor >> eventDiffModelSelected: ann [
	| diffNodeModel |
	
	diffNodeModel := ann value.
	lastDiffNodeModel = diffNodeModel ifTrue: [ ^ self ].
	
	self model: diffNodeModel.
	self withPanelWidgetDo: [ :w | w raise ]
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> initializePanelWidget: aPanelWidgetPresenter [

	super initializePanelWidget: aPanelWidgetPresenter.
	aPanelWidgetPresenter
		pinned: true;
		windowIcon: (self iconNamed: 'diff')
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> initializePresenters [

	super initializePresenters.
	
	self addStyle: 'diffEditor'.
	
	commitInfoPresenter := self instantiate: PulsarCommitInfoPresenter.
	commitInfoPresenter hide
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Diff';
		whenClosedDo: [ self windowClosed ]
]

{ #category : 'accessing - model' }
PulsarRepositoryDiffEditor >> model [

	^ super model ifNil: [ PulsarEmptyDiffNode new ]
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
		label: (self commitToString: self model root toCommitish);
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

{ #category : 'private' }
PulsarRepositoryDiffEditor >> panelFocused [

	logger trace.
	self notifyEditorActivated
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

{ #category : 'layout' }
PulsarRepositoryDiffEditor >> scrollableLayoutForContent [

	^ scrollableLayoutForContent ifNil: [ 
		scrollableLayoutForContent := SpScrollableLayout new
			child: SpBoxLayout newVertical;
			withoutHScrollbar;
			propagateNaturalHeight: true;
			yourself ]
]

{ #category : 'private' }
PulsarRepositoryDiffEditor >> updateCommitInfo [
	| commit |
	
	commit := self commitForInfo.

	commit ifNil: [
			commitInfoPresenter hide.
			^ self ].

	commitInfoPresenter
		model: commit;
		show
]

{ #category : 'private' }
PulsarRepositoryDiffEditor >> updatePatchContents [
	| contents nodes groups |
	
	nodes := Array streamContents: [ :stream |
		self model withAllChildrenDo: [ :eachModel | 
			eachModel hasChanges ifTrue: [ stream nextPut: eachModel ] ] ].

	contents := SpBoxLayout newVertical vAlignStart. 
	"40 is a magic number"
	groups := nodes groupsOf: 40.
	self withWindowDo: #jobStart.
	contents add: self newDiffHeader.
	groups withIndexDo: [ :eachGroup :index |
		self queueTask: [
			[
				eachGroup do: [ :eachModel |
					| patchPresenter |
					patchPresenter := self instantiate: self patchPresenterClass on: eachModel.
					patchPresenter notificationCenter: self notificationCenter.
					self application defer: [ contents add: patchPresenter ] ] ] 
			ensure: [
				index = groups size ifTrue: [ self withWindowDo: #jobEnd ] ] ] ].

	self application defer: [
		self scrollableLayoutForContent child: (self newPresenter
			layout: contents;
			yourself) ].
	
	self updateCommitInfo
]

{ #category : 'initialization' }
PulsarRepositoryDiffEditor >> updatePresenter [
	
	(self model isNil or: [ self model isEmpty ]) ifTrue: [ ^ self ].
	lastDiffNodeModel = self model ifTrue: [ ^ self ].
		
	lastDiffNodeModel := self model.

	self mutex critical: [
		"since large repositories (e.g. pharo itself) can have a lot of changes when working 
	 	 on an outdated branch, we skip the diff for the root, as calculate this will take a 
	 	 lot of time without giving real value to the user."
		(self model isRoot and: [ self model isBigChange ]) ifTrue: [ ^ self updateRootContents ].
		self queueTask: [ 
			self updatePatchContents.
			self updateCommitInfo ] ]
]

{ #category : 'private' }
PulsarRepositoryDiffEditor >> updateRootContents [

	scrollableLayoutForContent child: (self newPresenter
			 layout: (SpBoxLayout newVertical
					  vAlignStart;
					  add: (self newLabel
							   label: 'I can''t display the changes (changeset is too big). Please select a node of the diff tree';
							   yourself);
					  yourself);
			 yourself).
	commitInfoPresenter model: self commitForInfo
]

{ #category : 'private' }
PulsarRepositoryDiffEditor >> windowClosed [

	taskWorker ifNil: [ ^ self ].
	self purgeTaskWorker.
	taskWorker := nil
]
