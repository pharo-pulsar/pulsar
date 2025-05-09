Class {
	#name : 'DockContextEditor',
	#superclass : 'DockMethodEditor',
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

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
