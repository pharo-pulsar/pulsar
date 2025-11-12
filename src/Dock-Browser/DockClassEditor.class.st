Class {
	#name : 'DockClassEditor',
	#superclass : 'DockEditor',
	#instVars : [
		'commentPresenter',
		'commentOverlayLayout'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'private - updating' }
DockClassEditor >> commentChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].
	
	oldText = newText ifTrue: [ ^ self ].
	"(self isDirty 
		and: [ newText = self originalContent ])
		ifTrue: [ ^ self unmarkDirty ].
	
	self markDirty"
]

{ #category : 'initialization' }
DockClassEditor >> connectPresenters [

	super connectPresenters.
	
	commentPresenter
		whenTextChangedDo: [ :newText :oldText | self commentChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSaveComment: aString ];
		whenResetDo: [ self doResetComment ]
]

{ #category : 'layout' }
DockClassEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: ((commentOverlayLayout := SpOverlayLayout new)
				child: commentPresenter;
				yourself);
			add: ((editorOverlayLayout := SpOverlayLayout new) 
				child: editorPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'private - actions' }
DockClassEditor >> doBrowseSendersCommand: anAction [
	
	self systemNavigation 
		responderPresenter: anAction presenter;
		browseAllCallsOnClass: self model entity
]

{ #category : 'private - actions' }
DockClassEditor >> doResetComment [

	self updateComment
]

{ #category : 'private - actions' }
DockClassEditor >> doSaveComment: aString [

	self model saveComment: aString
]

{ #category : 'events' }
DockClassEditor >> eventModelChanged: ann [
	
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
DockClassEditor >> eventModelRemoved: anAnnouncememnt [ 

	self flag: #TODO
]

{ #category : 'events' }
DockClassEditor >> eventTestCaseEnded: aTestCaseEnded [

	"(self model isTestCase
		and: [ aTestCaseEnded testCase class = self model entity ])
		ifFalse: [ ^ self ].
		
	self halt.
	logger trace: aTestCaseEnded.
	self updateContentActions"
]

{ #category : 'events' }
DockClassEditor >> eventTestSuiteEnded: aTestSuiteEnded [

	(self model isTestCase
		and: [ aTestSuiteEnded testResult classesTested includes: self model entity ])
		ifFalse: [ ^ self ].

	logger trace: aTestSuiteEnded.

	self updateContentActions
]

{ #category : 'events' }
DockClassEditor >> eventThemeChanged: ann [

	super eventThemeChanged: ann.

	commentPresenter styleScheme: self application styleScheme
]

{ #category : 'initialization' }
DockClassEditor >> initializePresenters [

	super initializePresenters.
	
	self addStyle: 'dockClassEditor'.
	commentPresenter := self newCode
		addStyle: 'stCode';
		withoutSyntaxHighlight;
		yourself
]

{ #category : 'private' }
DockClassEditor >> originalContent [

	^ self model classDefinitionString
]

{ #category : 'initialization' }
DockClassEditor >> registerToSystemEvents [
	
	super registerToSystemEvents.
	
	self announcer
		when: TestSuiteEnded send: #eventTestSuiteEnded: to: self
]

{ #category : 'initialization' }
DockClassEditor >> updateBreadcrumbs [
	| name |
	
	name := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: name ]
]

{ #category : 'initialization' }
DockClassEditor >> updateComment [
	
	self updatingWhile: [
		commentPresenter text: (self model comment ifEmpty: [ 'No comment' ]) ]
]

{ #category : 'initialization' }
DockClassEditor >> updateEditor [
	
	self updatingWhile: [  
		editorPresenter text: self model classDefinitionString ]
]

{ #category : 'initialization' }
DockClassEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	super updatePresenter.
	self updateComment.
	self updateEditor.
	
	self flag: #REVIEW. "select template tab by defdault (as comment should be introduced later)?"
	self flag: #TODO. "I need a better way than to wait until it is built. I maybe need to implement #withAdapterPerformOrDefer: in the tab layout"
	"self model isNew ifTrue: [ 
		self whenBuiltDo: [ 
			self layout selectIndex: 2 ] ]"
]
