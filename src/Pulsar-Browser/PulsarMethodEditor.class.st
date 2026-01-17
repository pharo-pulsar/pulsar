"
An editor for methods.
"
Class {
	#name : 'PulsarMethodEditor',
	#superclass : 'PulsarEditor',
	#instVars : [
		'protocolPresenter',
		'linkedToSelection',
		'refactorPresenter'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing - actions' }
PulsarMethodEditor class >> defineActionsOn: aBuilder [
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
				description: 'Toggle method selection link.', String cr, 'Link this editor with the method selection in the class outline.';
				iconName: 'link';
				action: [ :aContext | aContext doToggleSelectionLinkCommand: action ] ] ]
]

{ #category : 'private - actions' }
PulsarMethodEditor >> activateWith: anActivationAnnouncement [

	anActivationAnnouncement hasSelection ifFalse: [ ^ self ].
	
	editorPresenter addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
		interval: anActivationAnnouncement selection;
		yourself)
]

{ #category : 'private' }
PulsarMethodEditor >> announceActivateClass [
	
	self notifyActivateEntity: self model asClassModel
]

{ #category : 'private' }
PulsarMethodEditor >> collectContentActions [

	^ SpActionGroup new
		add: super collectContentActions;
		add: self extraContentActions;
		yourself
]

{ #category : 'initialization' }
PulsarMethodEditor >> connectPresenters [

	super connectPresenters.
	protocolPresenter whenProtocolChangedDo: [ :aProtocolModel |
		self notifyEntityChanged: self model ]
]

{ #category : 'private - actions' }
PulsarMethodEditor >> doBrowseSendersCommand: anAction [
	
	self systemNavigation 
		responderPresenter: anAction presenter;
		browseAllSendersOf: self model name
]

{ #category : 'actions' }
PulsarMethodEditor >> doBrowseVersionsCommand: anAction [
	| popover versionsPresenter |

	popover := self newPopover.

	versionsPresenter := self
		instantiate: PulsarVersionsBrowser 
		on: self model newVersionsModel.
	versionsPresenter registerToBrowser: self window.

	popover := self newPopover
		presenter: versionsPresenter;
		relativeTo: anAction presenter;
		bePositionBottom;
		popupModal
]

{ #category : 'private - actions' }
PulsarMethodEditor >> doRequestChangeProtocol [

	protocolPresenter popupProtocol
]

{ #category : 'private - actions' }
PulsarMethodEditor >> doRunSampleInstanceCommand: anAction [
	| result |

	result := self model runScript.
	self flag: #TODO. "Open an inspector with the result"
]

{ #category : 'private - actions' }
PulsarMethodEditor >> doRunScriptCommand: anAction [

	self model runScript
]

{ #category : 'private - actions' }
PulsarMethodEditor >> doSubmit: aString [

	self updatingWhile: [
		super doSubmit: aString.
		self updateContentActions ]
]

{ #category : 'private - actions' }
PulsarMethodEditor >> doToggleSelectionLinkCommand: anAction [
	
	linkedToSelection := linkedToSelection not.
	
	linkedToSelection 
		ifTrue: [ self addStyle: 'dockEditorLinked' ]
		ifFalse: [ self removeStyle: 'dockEditorLinked' ]
]

{ #category : 'events - system' }
PulsarMethodEditor >> eventMethodModified: anAnnouncement [
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
PulsarMethodEditor >> eventMethodRecategorized: anAnnouncement [

	self model entity = anAnnouncement methodRecategorized
		ifFalse: [ ^ self ].

	self updateProtocol
]

{ #category : 'events - system' }
PulsarMethodEditor >> eventMethodRemoved: anAnnouncement [


	(self model entity = anAnnouncement methodRemoved)
		ifFalse: [ ^ self ].
	
	self forceClose
]

{ #category : 'events' }
PulsarMethodEditor >> eventModelChanged: ann [
	
	ann value = self model ifFalse: [ ^ self ].
	
	super eventModelChanged: ann.
	self updateProtocol
]

{ #category : 'events' }
PulsarMethodEditor >> eventModelRemoved: anAnnouncememnt [ 

	anAnnouncememnt value = self model ifFalse: [ ^ self ].

	self withPanelWindowDo: [ :aWindow | aWindow close ]
]

{ #category : 'events' }
PulsarMethodEditor >> eventModelSelected: ann [
	
	linkedToSelection ifFalse: [ ^ self ].
	
	self model: ann value
]

{ #category : 'events' }
PulsarMethodEditor >> eventTestCaseEnded: aTestCaseEnded [

	(self model isTestMethod
		and: [ aTestCaseEnded testCase class = self model methodClass 
		and: [ aTestCaseEnded testSelector = self model selector ] ])
		ifFalse: [ ^ self ].

	logger trace: aTestCaseEnded.
	self updateContentActions
]

{ #category : 'private' }
PulsarMethodEditor >> extraContentActions [ 
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
PulsarMethodEditor >> initialize [

	linkedToSelection := false.
	super initialize
]

{ #category : 'initialization' }
PulsarMethodEditor >> initializePresenters [

	super initializePresenters.
	
	protocolPresenter := self instantiate: PulsarProtocolButtonPresenter.
	toolbarPresenter addPresenter: protocolPresenter.
	
	refactorPresenter := self newMenuButton
		addStyle: 'flat'; 
		icon: (self iconNamed: #refactor);
		help: 'Refactors';
		yourself.
	toolbarPresenter addPresenter: refactorPresenter.
	
	self addStyle: 'dockMethodEditor'
]

{ #category : 'private - announcing' }
PulsarMethodEditor >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'private' }
PulsarMethodEditor >> originalContent [

	^ self model sourceCode
]

{ #category : 'initialization' }
PulsarMethodEditor >> registerToEvents [

	super registerToEvents.
	
	self announcer 
		when: PulsarMethodModelSelected 
		send: #eventModelSelected: 
		to: self
]

{ #category : 'initialization' }
PulsarMethodEditor >> registerToSystemEvents [

	super registerToSystemEvents.
	self announcer 
		when: MethodModified send: #eventMethodModified: to: self;
		when: MethodRemoved send: #eventMethodRemoved: to: self
]

{ #category : 'initialization' }
PulsarMethodEditor >> updateBreadcrumbs [
	| className methodName |

	className := self model methodClassName.
	methodName := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		aBreadcrumb 
			addLinkSegment: className action: [ self announceActivateClass ];
			addSegment: methodName ]
]

{ #category : 'initialization' }
PulsarMethodEditor >> updateContentActions [

	super updateContentActions.
	refactorPresenter actions: (self model refactorActionsWithContextOn: self)
]

{ #category : 'initialization' }
PulsarMethodEditor >> updateEditor [

	editorPresenter 
		beForMethod: self model entity;
		text: self model sourceCode
]

{ #category : 'initialization' }
PulsarMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [
		super updatePresenter.
		self updatingWhile: [  
			self updateProtocol.
			self updateEditor.
			self updateSearch ] ]
]

{ #category : 'initialization' }
PulsarMethodEditor >> updateProtocol [

	protocolPresenter model: self model
]
