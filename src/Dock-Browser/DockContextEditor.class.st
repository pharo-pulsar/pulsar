Class {
	#name : 'DockContextEditor',
	#superclass : 'DockMethodEditor',
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'as yet unclassified' }
DockContextEditor >> beFixedToDock [
	"prepare this context editor as 'fixed' to the debugger dock (it will not be modified 
	 when switching contexts"
]

{ #category : 'private' }
DockContextEditor >> grabDebugToolbar [
	| lastOwner debugToolbarPresenter |
	
	logger trace.
	
	"window will be the debugger, I can access the toolbar there"
	debugToolbarPresenter := self withWindowDo: [ :w | w debugToolbarPresenter ].
	
	lastOwner := debugToolbarPresenter lastOwner.
	(lastOwner isNotNil and: [ lastOwner ~= self ]) ifTrue: [ 
		logger trace: lastOwner.
		lastOwner removeOverlay: debugToolbarPresenter ].
	
	debugToolbarPresenter lastOwner: self.
	self 
		addOverlay: debugToolbarPresenter 
		withConstraints: [ :c | c hAlignCenter; vAlignEnd ]
]

{ #category : 'private' }
DockContextEditor >> panelFocused [

	super panelFocused.
	self grabDebugToolbar
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

	logger trace: self model selectedCodeRange.
	editorPresenter
		beForContext: self model context;
		text: self model sourceCode;
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: self model selectedCodeRange;
			yourself)
]

{ #category : 'initialization' }
DockContextEditor >> updatePresenter [

	self model ifNil: [ ^ self ].

	super updatePresenter
]
