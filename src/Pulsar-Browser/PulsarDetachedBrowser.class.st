"
A browser to contain detached editors.
This will be the answer to the ""Detach"" action available for editors.
"
Class {
	#name : 'PulsarDetachedBrowser',
	#superclass : 'PulsarBaseBrowser',
	#category : 'Pulsar-Browser-View-DetachedBrowser',
	#package : 'Pulsar-Browser',
	#tag : 'View-DetachedBrowser'
}

{ #category : 'private' }
PulsarDetachedBrowser >> composeTitle [

	^ 'Pharo({1}): {2}' format: {
		FileLocator image base.
		', ' join: (self editors collect: [ :each | each title ]) }
]

{ #category : 'private - definitions' }
PulsarDetachedBrowser >> defineViewActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #view with: [ :group | group 
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Open Class Outline';
			description: 'Open a class outline panel';
			action: [ self doOpenClassOutlineView ] ] ]
]

{ #category : 'private - actions' }
PulsarDetachedBrowser >> doOpenClassOutlineView [
	| outlineView |

	outlineView := (self findPresenterClass: PulsarClassOutlineView)
		ifNil: [ self addPresenterClass: PulsarClassOutlineView ].
		
	outlineView takeKeyboardFocus
]

{ #category : 'initialization' }
PulsarDetachedBrowser >> initializeWindow: aWindowPresenter [


	super initializeWindow: aWindowPresenter.
	self updateTitle

]

{ #category : 'accessing - snapshot' }
PulsarDetachedBrowser >> snapshot [

	^ PulsarDetachedBrowserSnapshot on: self
]

{ #category : 'initialization' }
PulsarDetachedBrowser >> updateTitle [
	| newTitle |

	newTitle := self composeTitle.
	logger trace: newTitle.
	self title: newTitle
]
