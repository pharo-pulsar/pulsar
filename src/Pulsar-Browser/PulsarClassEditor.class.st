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
		'editorPanelPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
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
				description: 'Toggle class selection link';
				iconName: 'link';
				action: [ :aContext | aContext doToggleSelectionLinkCommand: action ] ] ]
]

{ #category : 'private' }
PulsarClassEditor >> collectContentActions [

	^ SpActionGroup new
		add: super collectContentActions;
		add: self extraContentActions;
		yourself
]

{ #category : 'private - updating' }
PulsarClassEditor >> commentChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].
	
	oldText = newText ifTrue: [ ^ self ].
	"(self isDirty 
		and: [ newText = self originalContent ])
		ifTrue: [ ^ self unmarkDirty ].
	
	self markDirty"
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

	self updateComment
]

{ #category : 'private - actions' }
PulsarClassEditor >> doSaveComment: aString [

	self model saveComment: aString
]

{ #category : 'private - actions' }
PulsarClassEditor >> doToggleDefinitionCommand: anAction [

	editorPanelPresenter visible: editorPanelPresenter isVisible not
]

{ #category : 'private - actions' }
PulsarClassEditor >> doToggleSelectionLinkCommand: anAction [
	
	linkedToSelection := linkedToSelection not.
	
	linkedToSelection 
		ifTrue: [ self addStyle: 'dockEditorLinked' ]
		ifFalse: [ self removeStyle: 'dockEditorLinked' ]
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

{ #category : 'private' }
PulsarClassEditor >> extraContentActions [
	| nearestWindow |

	self flag: #TODO. "I am linearizing this because meh... so far, so good. I need 
	to revisit this when I complete the refactor of actions"

	nearestWindow := self nearWindowLike.
	"no extra actions in popovers"
	(nearestWindow isNotNil and: [ nearestWindow isPopover ])
		ifTrue: [ ^ SpActionGroup new ].

	"^ {self model actions actionsFor: #refactoring}, (self actions actionsFor: #editorActions) entries"
	^ self actions actionsFor: #editorActions
]

{ #category : 'initialization' }
PulsarClassEditor >> initialize [

	linkedToSelection := false.
	super initialize
]

{ #category : 'initialization' }
PulsarClassEditor >> initializePresenters [

	super initializePresenters.
	
	self addStyle: 'dockClassEditor'.
	commentPresenter := (self instantiate: SeEditorPresenter)
		addStyle: 'stCode';
		withHyperlinks;
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

{ #category : 'initialization' }
PulsarClassEditor >> updateBreadcrumbs [
	| name |
	
	name := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: name ]
]

{ #category : 'initialization' }
PulsarClassEditor >> updateComment [
	
	self updatingWhile: [
		commentPresenter text: self model commentOrTemplate ]
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
