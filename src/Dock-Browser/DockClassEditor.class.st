Class {
	#name : 'DockClassEditor',
	#superclass : 'DockEditor',
	#instVars : [
		'commentPresenter'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'layout' }
DockClassEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: commentPresenter;
			add: editorPresenter;
			yourself);
		yourself
]

{ #category : 'private - actions' }
DockClassEditor >> doResetComment [

	self updateComment
]

{ #category : 'private - actions' }
DockClassEditor >> doSaveComment [

	self model saveComment: commentPresenter text
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

{ #category : 'initialization' }
DockClassEditor >> initializePresenters [

	super initializePresenters.
	
	self addStyle: 'dockClassEditor'.
	commentPresenter := self newCode
		withoutSyntaxHighlight;
		whenSubmitDo: [ self doSaveComment ];
		whenResetDo: [ self doResetComment ];
		yourself
]

{ #category : 'private' }
DockClassEditor >> originalContent [

	^ self model classDefinitionString
]

{ #category : 'initialization' }
DockClassEditor >> updateBreadcrumbs [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: self model name ]
]

{ #category : 'initialization' }
DockClassEditor >> updateComment [
	
	commentPresenter text: (self model comment ifEmpty: [ 'No comment' ])
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
