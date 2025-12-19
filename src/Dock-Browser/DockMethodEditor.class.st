"
An editor for methods.
"
Class {
	#name : 'DockMethodEditor',
	#superclass : 'DockEditor',
	#instVars : [
		'protocolPresenter',
		'linkedToSelection'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
DockMethodEditor class >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder 
		addGroup: #structuring with: [ :group | group 
			priority: -10;
			name: 'Structure';
			beDisplayedAsGroup;
			addActionWith: [ :anAction | anAction
				name: 'Classify method';
				description: 'Change protocol of current method';
				iconName: 'tag';
				shortcutKey:  $p mod1 shift;
				action: [ :aContext | aContext doRequestChangeProtocol ] ] ];
		addGroup: #editorActions with: [ :group | group
			priority: 1;
			name: 'Editor';
			beDisplayedAsGroup;
			addActionWith: [ :action | action 
				name: 'Toggle link';
				description: 'Toggle method selection link';
				iconName: 'link';
				action: [ :aContext | aContext doToggleSelectionLinkCommand: action ] ] ]
]

{ #category : 'private - actions' }
DockMethodEditor >> activateWith: anActivationAnnouncement [

	anActivationAnnouncement hasSelection ifFalse: [ ^ self ].
	
	editorPresenter addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
		interval: anActivationAnnouncement selection;
		yourself)
]

{ #category : 'private' }
DockMethodEditor >> announceActivateClass [
	
	self notifyActivateEntity: self model asClassModel
]

{ #category : 'private' }
DockMethodEditor >> collectContentActions [

	^ SpActionGroup new
		add: super collectContentActions;
		add: self extraContentActions;
		yourself
]

{ #category : 'initialization' }
DockMethodEditor >> connectPresenters [

	super connectPresenters.
	protocolPresenter whenProtocolChangedDo: [ :aProtocolModel |
		self notifyEntityChanged: self model ]
]

{ #category : 'private - actions' }
DockMethodEditor >> doBrowseSendersCommand: anAction [
	
	self systemNavigation 
		responderPresenter: anAction presenter;
		browseAllSendersOf: self model name
]

{ #category : 'actions' }
DockMethodEditor >> doBrowseVersionsCommand: anAction [
	| popover versionsPresenter |

	popover := self newPopover.

	versionsPresenter := self
		instantiate: DockVersionsBrowser 
		on: self model newVersionsModel.
	versionsPresenter registerToDock: self window.

	popover := self newPopover
		presenter: versionsPresenter;
		relativeTo: anAction presenter;
		bePositionBottom;
		popupModal
]

{ #category : 'private - actions' }
DockMethodEditor >> doRequestChangeProtocol [

	protocolPresenter popupProtocol
]

{ #category : 'private - actions' }
DockMethodEditor >> doRunSampleInstanceCommand: anAction [
	| result |

	result := self model runScript.
	self flag: #TODO. "Open an inspector with the result"
]

{ #category : 'private - actions' }
DockMethodEditor >> doRunScriptCommand: anAction [

	self model runScript
]

{ #category : 'private - actions' }
DockMethodEditor >> doSubmit: aString [

	self updatingWhile: [
		super doSubmit: aString.
		self updateContentActions ]
]

{ #category : 'private - actions' }
DockMethodEditor >> doToggleSelectionLinkCommand: anAction [
	
	linkedToSelection := linkedToSelection not.
	
	linkedToSelection 
		ifTrue: [ self addStyle: 'dockEditorLinked' ]
		ifFalse: [ self removeStyle: 'dockEditorLinked' ]
]

{ #category : 'events - system' }
DockMethodEditor >> eventMethodModified: anAnnouncement [
	| methodModified |

	(self model entity = anAnnouncement method 
		or: [ self model entity = anAnnouncement oldMethod ])
		ifFalse: [ ^ self ].
	"Is me who is updating, get out"
	self isUpdating ifTrue: [ ^ self ].
	
	self isDirty ifTrue: [ 
		"self markOutdatedMethod."
		^ self ].
		
	methodModified := anAnnouncement method.
		
	logger trace: methodModified.
		
	"update model"
	self model entity: methodModified. 
	"update presenter"
	self updatePresenter
]

{ #category : 'events - system' }
DockMethodEditor >> eventMethodRecategorized: anAnnouncement [

	self model entity = anAnnouncement methodRecategorized
		ifFalse: [ ^ self ].

	self updateProtocol
]

{ #category : 'events - system' }
DockMethodEditor >> eventMethodRemoved: anAnnouncement [


	(self model entity = anAnnouncement methodRemoved)
		ifFalse: [ ^ self ].
	
	self forceClose
]

{ #category : 'events' }
DockMethodEditor >> eventModelChanged: ann [
	
	ann value = self model ifFalse: [ ^ self ].
	
	super eventModelChanged: ann.
	self updateProtocol
]

{ #category : 'events' }
DockMethodEditor >> eventModelRemoved: anAnnouncememnt [ 

	anAnnouncememnt value = self model ifFalse: [ ^ self ].

	self withPanelWindowDo: [ :aWindow | aWindow close ]
]

{ #category : 'events' }
DockMethodEditor >> eventModelSelected: ann [
	
	linkedToSelection ifFalse: [ ^ self ].
	
	self model: ann value
]

{ #category : 'events' }
DockMethodEditor >> eventTestCaseEnded: aTestCaseEnded [

	(self model isTestMethod
		and: [ aTestCaseEnded testCase class = self model methodClass 
		and: [ aTestCaseEnded testSelector = self model selector ] ])
		ifFalse: [ ^ self ].

	logger trace: aTestCaseEnded.
	self updateContentActions
]

{ #category : 'private' }
DockMethodEditor >> extraContentActions [ 
	| nearestWindow |

	self flag: #TODO. "I am linearizing this because meh... so far, so good. I need 
	to revisit this when I complete the refactor of actions"

	nearestWindow := self nearWindowLike.
	"no extra actions in popovers"
	(nearestWindow isNotNil and: [ nearestWindow isPopover ])
		ifTrue: [ ^ SpActionGroup new ].

	^ self actions actionsFor: #editorActions
]

{ #category : 'initialization' }
DockMethodEditor >> initialize [

	linkedToSelection := false.
	super initialize
]

{ #category : 'initialization' }
DockMethodEditor >> initializePresenters [

	super initializePresenters.
	
	protocolPresenter := self instantiate: DockProtocolButtonPresenter.
	toolbarPresenter addPresenter: protocolPresenter.
	
	self addStyle: 'dockMethodEditor'
]

{ #category : 'private - announcing' }
DockMethodEditor >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private' }
DockMethodEditor >> originalContent [

	^ self model sourceCode
]

{ #category : 'initialization' }
DockMethodEditor >> registerToEvents [

	super registerToEvents.
	
	self announcer 
		when: DockMethodModelSelected 
		send: #eventModelSelected: 
		to: self
]

{ #category : 'initialization' }
DockMethodEditor >> registerToSystemEvents [

	super registerToSystemEvents.
	self announcer 
		when: MethodModified send: #eventMethodModified: to: self;
		when: MethodRemoved send: #eventMethodRemoved: to: self
]

{ #category : 'initialization' }
DockMethodEditor >> updateBreadcrumbs [
	| className methodName |

	className := self model methodClassName.
	methodName := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb 
			addLinkSegment: className action: [ self announceActivateClass ];
			addSegment: methodName ]
]

{ #category : 'initialization' }
DockMethodEditor >> updateEditor [

	editorPresenter 
		beForMethod: self model entity;
		text: self model sourceCode
]

{ #category : 'initialization' }
DockMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		super updatePresenter.
		self updatingWhile: [  
			self updateProtocol.
			self updateEditor.
			self updateSearch ] ]
]

{ #category : 'initialization' }
DockMethodEditor >> updateProtocol [

	protocolPresenter model: self model
]
