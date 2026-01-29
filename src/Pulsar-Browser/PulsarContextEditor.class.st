"
An editor for stack contexts (that are like methods, but with special behavior) 
"
Class {
	#name : 'PulsarContextEditor',
	#superclass : 'PulsarMethodEditor',
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'layout' }
PulsarContextEditor >> defaultLayout [

	^ SpBoxLayout newVertical 
		add: super defaultLayout;
		yourself
]

{ #category : 'private - definitions' }
PulsarContextEditor >> defineDecorationActionsOn: aBuilder [
	<dockActions>
	
	"no decorations for now"
]

{ #category : 'events' }
PulsarContextEditor >> eventContextChanged: anAnnouncement [
	| contextModel |
	
	contextModel := anAnnouncement value.
	logger trace: contextModel.
	
	self model = contextModel ifFalse: [ ^ self ].
	self updatePresenter
]

{ #category : 'private' }
PulsarContextEditor >> extraContentActions [

	"not having for the moment, and I do not want to 'link' context editors... which are 
	 already linked to the stack"
	^ SpActionGroup new
]

{ #category : 'private' }
PulsarContextEditor >> grabDebugToolbar [
	| debugToolbarPresenter |
	
	"the idea of this is that if we have different context editors, we have just one debug toolbar, 
	 that will be moving between the active ones...
	 No idea if this is a good idea or is just better to have many toolbars and just toggle visible status, 
	 but as right now I just have one since context editor... is not a problem ;)"
	
	logger trace.
	
	"window will be the debugger, I can access the toolbar there"
	debugToolbarPresenter := self withWindowDo: [ :w | w debugToolbarPresenter ].
	debugToolbarPresenter model: self model.

	debugToolbarPresenter lastOwner == self ifTrue: [ ^ self ].

	"(lastOwner isNotNil and: [ lastOwner ~= self ]) ifTrue: [ 
		logger trace: lastOwner.
		lastOwner removeOverlay: debugToolbarPresenter ]."
	
	debugToolbarPresenter lastOwner: self.
	
	self layout 
		add: debugToolbarPresenter 
		expand: false
]

{ #category : 'initialization' }
PulsarContextEditor >> initializePresenters [

	super initializePresenters.
	"a context editor is always linked for now (there is just one, linked to the stack)."
	editorPresenter addStyle: 'pulsarEditorLinked'
]

{ #category : 'private' }
PulsarContextEditor >> panelFocused [

	super panelFocused.
	self grabDebugToolbar
]

{ #category : 'initialization' }
PulsarContextEditor >> registerToEvents [

	super registerToEvents.
	self announcer
		when: PulsarDebuggerContextChanged
		send: #eventContextChanged:
		to: self
]

{ #category : 'initialization' }
PulsarContextEditor >> updateBreadcrumbs [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb 
			addSegment: self model packageName;
			addLinkSegment: self model methodClassName action: [ self announceActivateClass ];
			addLinkSegment: self model methodName action: [ self announceActivateMethod ] ]
]

{ #category : 'initialization' }
PulsarContextEditor >> updateEditor [
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
PulsarContextEditor >> updateModel: aString [
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
PulsarContextEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	super updatePresenter
]
