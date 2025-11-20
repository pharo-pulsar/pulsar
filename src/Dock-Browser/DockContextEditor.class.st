"
An editor for stack contexts (that are like methods, but with special behavior) 
"
Class {
	#name : 'DockContextEditor',
	#superclass : 'DockMethodEditor',
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'accessing' }
DockContextEditor >> beFixedToDock [
	"prepare this context editor as 'fixed' to the debugger dock (it will not be modified 
	 when switching contexts"
]

{ #category : 'layout' }
DockContextEditor >> defaultLayout [

	^ SpBoxLayout newVertical 
		add: super defaultLayout;
		yourself
]

{ #category : 'events' }
DockContextEditor >> eventContextChanged: anAnnouncement [
	| contextModel |
	
	contextModel := anAnnouncement value.
	logger trace: contextModel.
	
	self model = contextModel ifFalse: [ ^ self ].
	self updatePresenter
]

{ #category : 'private' }
DockContextEditor >> grabDebugToolbar [
	| lastOwner debugToolbarPresenter |
	
	"the idea of this is that if we have different context editors, we have just one debug toolbar, 
	 that will be moving between the active ones...
	 No idea if this is a good idea or is just better to have many toolbars and just toggle visible status, 
	 but as right now I just have one since context editor... is not a problem ;)"
	
	logger trace.
	
	"window will be the debugger, I can access the toolbar there"
	debugToolbarPresenter := self withWindowDo: [ :w | w debugToolbarPresenter ].
	debugToolbarPresenter model: self model.

	lastOwner := debugToolbarPresenter lastOwner.
	lastOwner == self ifTrue: [ ^ self ].

	"(lastOwner isNotNil and: [ lastOwner ~= self ]) ifTrue: [ 
		logger trace: lastOwner.
		lastOwner removeOverlay: debugToolbarPresenter ]."
	
	debugToolbarPresenter lastOwner: self.
	
	self layout 
		add: debugToolbarPresenter 
		expand: false
]

{ #category : 'private' }
DockContextEditor >> panelFocused [

	super panelFocused.
	self grabDebugToolbar
]

{ #category : 'initialization' }
DockContextEditor >> registerToEvents [

	super registerToEvents.
	self announcer
		when: DockDebuggerContextChanged
		send: #eventContextChanged:
		to: self
]

{ #category : 'initialization' }
DockContextEditor >> updateBreadcrumbs [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb 
			addSegment: self model packageName;
			addLinkSegment: self model methodClassName action: [ self announceActivateClass ];
			addLinkSegment: self model methodName action: [ self announceActivateMethod ] ]
]

{ #category : 'initialization' }
DockContextEditor >> updateEditor [
	| context source selectedCodeRange |

	context := self model context.
	source := self model sourceCode.
	selectedCodeRange := self model selectedCodeRange.
	editorPresenter
		beForContext: context;
		text: source;
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: selectedCodeRange;
			yourself);
		scrollValue: 0@(source lineNumberCorrespondingToIndex: selectedCodeRange first)
]

{ #category : 'private - actions' }
DockContextEditor >> updateModel: aString [
	| force |

	force := false.
	^  [ 
		self model 
			updateWith: aString
			notifying: editorPresenter interactionModel
			force: force ]
		on: DebugAttemptToRewindPostMortemError 
		do: [ :e | 
			force := self confirm: 'Can not rewind post mortem context for new method. Accept anyway?'.
			force ifTrue: [ e retry ].
			false ]
]

{ #category : 'initialization' }
DockContextEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	super updatePresenter
]
