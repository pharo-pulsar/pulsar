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
			name: 'Class Outline';
			description: 'Open a class outline panel';
			action: [ self doOpenClassOutlineView ] ];
		addActionWith: [ :action | action 
			name: 'Editor Stack';
			description: 'Open the editor stack panel';
			action: [ self doOpenEditorStackView ] ] ]
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

{ #category : 'initialization' }
PulsarDetachedBrowser >> initializeWorkspace [

	super initializeWorkspace.

	"defaults"
	self startWidth: 300.
	self endWidth: 300.
	self topHeight: 250.
	self bottomHeight: 250
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

{ #category : 'private' }
PulsarDetachedBrowser >> viewDocked: aPresenter [

	(PulsarBrowserEnsureClassOverviewVisitor on: self) visit: aPresenter
]
