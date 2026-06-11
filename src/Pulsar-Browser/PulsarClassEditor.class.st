"
An editor for classes.
As most of its properties will be edited the class outline panel (`PulsarClassOutlineView`), this will be used mostly to edit/consult comments. 
There will be, however, the possibility to toggle the fluid class definition, to provide lowlevel access to class defintions.
"
Class {
	#name : 'PulsarClassEditor',
	#superclass : 'PulsarEditor',
	#instVars : [
		'commentPresenter',
		'commentOverlayLayout',
		'linkedToSelection',
		'editorPanelPresenter',
		'refactorPresenter',
		'commentDirty',
		'commentDirtyMarkerPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'private - definitions' }
PulsarClassEditor class >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder 
		addGroup: #editorActions 
		with: [ :group | group
			priority: 1;
			name: 'Editor';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'Toggle definition';
				description: 'Toggle fluid class definition';
				iconName: 'panel-bottom';
				action: [ :aContext | aContext doToggleDefinitionCommand: action ] ];
			addActionWith: [ :action | action 
				name: 'Toggle link';
				description: 'Toggle class selection link.', String cr, 'Link this editor with the class selection in the project view.';
				
				iconName: 'link';
				action: [ :aContext | aContext doToggleSelectionLinkCommand: action ] ] ]
]

{ #category : 'visiting' }
PulsarClassEditor >> acceptVisitor: aVisitor [

	^ aVisitor visitClassEditor: self
]

{ #category : 'private - updating' }
PulsarClassEditor >> commentChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].

	oldText = newText ifTrue: [ ^ self ].
	(commentDirty and: [ newText = self model commentOrTemplate ]) ifTrue: [ ^ self commentUnmarkDirty ].

	self commentMarkDirty
]

{ #category : 'private' }
PulsarClassEditor >> commentDirtyMarkerPresenter [

	^ commentDirtyMarkerPresenter ifNil: [ commentDirtyMarkerPresenter := self newCommentDirtyMarkerPresenter ]
]

{ #category : 'private - updating' }
PulsarClassEditor >> commentMarkDirty [

	commentDirty ifTrue: [ ^ self ].
	commentDirty := true.
	self withPanelWidgetDo: [ :w | w modified: true ].
	self commentOverlayLayout addOverlay: self commentDirtyMarkerPresenter withConstraints: [ :c |
			c
				hAlignEnd;
				vAlignStart ]
]

{ #category : 'private - overlay' }
PulsarClassEditor >> commentOverlayLayout [

	^ commentOverlayLayout ifNil: [ commentOverlayLayout := SpOverlayLayout new ]
]

{ #category : 'private - updating' }
PulsarClassEditor >> commentUnmarkDirty [

	commentDirty ifFalse: [ ^ self ].
	commentDirty := false.
	self commentOverlayLayout removeOverlay: self commentDirtyMarkerPresenter.
	self isDirty ifFalse: [ self withPanelWidgetDo: [ :w | w modified: false ] ]
]

{ #category : 'initialization' }
PulsarClassEditor >> connectPresenters [

	super connectPresenters.
	
	commentPresenter
		whenTextChangedDo: [ :newText :oldText | self commentChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSaveComment: aString ];
		whenResetDo: [ self doResetComment ]
]

{ #category : 'layout' }
PulsarClassEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: ((commentOverlayLayout := SpOverlayLayout new)
				child: commentPresenter;
				yourself);
			add: ((editorPanelPresenter := self newPresenter)
				layout: (SpBoxLayout newVertical
					add: ((editorOverlayLayout := SpOverlayLayout new) 
						child: editorPresenter;
						yourself);
					add: searchBarPresenter expand: false;				
					yourself);
				yourself);
			yourself);
		yourself
]

{ #category : 'private - actions' }
PulsarClassEditor >> doBrowseSendersCommand: anAction [
	
	self systemNavigation 
		responderPresenter: anAction presenter;
		browseAllCallsOnClass: self model entity
]

{ #category : 'private - actions' }
PulsarClassEditor >> doResetComment [

	self updateComment.
	self commentUnmarkDirty
]

{ #category : 'private - actions' }
PulsarClassEditor >> doSaveComment: aString [

	self model saveComment: aString.
	self commentUnmarkDirty
]

{ #category : 'private - actions' }
PulsarClassEditor >> doToggleDefinitionCommand: anAction [

	editorPanelPresenter visible: editorPanelPresenter isVisible not
]

{ #category : 'private - actions' }
PulsarClassEditor >> doToggleSelectionLinkCommand: anAction [
	
	linkedToSelection := linkedToSelection not.
	
	linkedToSelection 
		ifTrue: [ self addStyle: 'pulsarEditorLinked' ]
		ifFalse: [ self removeStyle: 'pulsarEditorLinked' ]
]

{ #category : 'events' }
PulsarClassEditor >> eventModelChanged: ann [
	
	ann value = self model ifFalse: [ ^ self ].
	self isDirty 
		ifTrue: [
			self flag: #TODO. "Maybe mark dirty as a conflict?"
			"updating should prevent to modify the edited content"
			self updatingWhile: [
				self updatePresenter ] ]
		ifFalse: [
			self updatePresenter ]
]

{ #category : 'events' }
PulsarClassEditor >> eventModelRemoved: anAnnouncememnt [ 

	self flag: #TODO
]

{ #category : 'events' }
PulsarClassEditor >> eventModelSelected: ann [
	
	linkedToSelection ifFalse: [ ^ self ].
	
	self model: ann value.
	"self notificationCenter announce: ann value newActivationAnnouncement"
]

{ #category : 'events' }
PulsarClassEditor >> eventTestCaseEnded: aTestCaseEnded [

	"(self model isTestCase
		and: [ aTestCaseEnded testCase class = self model entity ])
		ifFalse: [ ^ self ].
		
	self halt.
	logger trace: aTestCaseEnded.
	self updateContentActions"
]

{ #category : 'events' }
PulsarClassEditor >> eventTestSuiteEnded: aTestSuiteEnded [

	(self model isTestCase
		and: [ aTestSuiteEnded testResult classesTested includes: self model entity ])
		ifFalse: [ ^ self ].

	logger trace: aTestSuiteEnded.

	self updateContentActions
]

{ #category : 'events' }
PulsarClassEditor >> eventThemeChanged: ann [

	super eventThemeChanged: ann.

	commentPresenter styleScheme: self application styleScheme
]

{ #category : 'initialization' }
PulsarClassEditor >> initialize [

	linkedToSelection := false.
	commentDirty := false.
	super initialize
]

{ #category : 'initialization' }
PulsarClassEditor >> initializePresenters [

	super initializePresenters.
	
	self addStyle: 'pulsarClassEditor'.

	refactorPresenter := self newMenuButton
		addStyle: 'flat'; 
		icon: (self iconNamed: #refactor);
		help: 'Refactors';
		yourself.
	toolbarPresenter addPresenter: refactorPresenter.
	
	commentPresenter := (self instantiate: SeEditorPresenter)
		addStyle: 'stCode';
		withoutLineNumbers;
		withHyperlinks;
		yourself
]

{ #category : 'testing' }
PulsarClassEditor >> isDirty [

	^ dirty or: [ commentDirty ]
]

{ #category : 'private' }
PulsarClassEditor >> newCommentDirtyMarkerPresenter [

	^ self newToolbar
		  addStyle: 'pulsarDirtyMarker';
		  beIcons;
		  add: (self newToolbarButton
				   addStyle: 'accept';
				   icon: (self iconNamed: #accept);
				   action: [ self doSaveComment: commentPresenter text ];
				   help: 'Accept changes';
				   yourself);
		  add: (self newToolbarButton
				   addStyle: 'cancel';
				   icon: (self iconNamed: #cancel);
				   action: [ self doResetComment ];
				   help: 'Cancel changes';
				   yourself);
		  yourself
]

{ #category : 'private' }
PulsarClassEditor >> originalContent [

	^ self model classDefinitionString
]

{ #category : 'initialization' }
PulsarClassEditor >> registerToEvents [
	
	super registerToEvents.
	self announcer 
		when: PulsarClassModelSelected 
		send: #eventModelSelected: 
		to: self
]

{ #category : 'initialization' }
PulsarClassEditor >> registerToSystemEvents [
	
	super registerToSystemEvents.
	
	self announcer
		when: TestSuiteEnded send: #eventTestSuiteEnded: to: self
]

{ #category : 'private - actions' }
PulsarClassEditor >> saveContent [

	| result |
	result := super saveContent.
	commentDirty ifTrue: [ self doSaveComment: commentPresenter text ].

	^ result
]

{ #category : 'private - updating' }
PulsarClassEditor >> unmarkDirty [

	dirty ifFalse: [ ^ self ].
	dirty := false.
	self removeOverlay: self dirtyMarkerPresenter.
	self isDirty ifFalse: [ self withPanelWidgetDo: [ :w | w modified: false ] ]
]

{ #category : 'initialization' }
PulsarClassEditor >> updateBreadcrumbs [
	| name |
	
	name := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb 
			addSegment: name;
			addButtonSegment: 'copy-to-clipboard'
				help: ('Copy {1} to the clipboard' format: { self model fullName })
				action: [ self doCopyToClipboard ] ]
]

{ #category : 'initialization' }
PulsarClassEditor >> updateComment [
	
	self updatingWhile: [
		commentPresenter text: self model commentOrTemplate ]
]

{ #category : 'initialization' }
PulsarClassEditor >> updateContentActions [

	super updateContentActions.
	refactorPresenter actions: (self model actionsWithContextOn: self) beDisplayedAsGroup
]

{ #category : 'initialization' }
PulsarClassEditor >> updateEditor [
	
	self updatingWhile: [  
		editorPresenter 
			"this makes the editor not well styled"
			"beForBehavior: self model instanceSide;"
			text: self model classDefinitionString ]
]

{ #category : 'initialization' }
PulsarClassEditor >> updatePresenter [

	commentPresenter 
		styleScheme: self application styleScheme;
		language: 'markdown'.


	self model ifNil: [ ^ self ].
	
	super updatePresenter.
	
	self updateComment.
	self updateEditor
]
