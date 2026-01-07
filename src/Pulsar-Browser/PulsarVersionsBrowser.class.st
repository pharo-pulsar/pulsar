Class {
	#name : 'PulsarVersionsBrowser',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter + PulsarTPanelWindow + PulsarTSnapshot + PulsarTActionContainer',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait + PulsarTPanelWindow classTrait + PulsarTSnapshot classTrait + PulsarTActionContainer classTrait',
	#instVars : [
		'headerPresenter',
		'versionListPresenter',
		'patchPresenter',
		'sourcePresenter'
	],
	#category : 'Pulsar-Browser-Tool-Versions',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Versions'
}

{ #category : 'accessing - actions' }
PulsarVersionsBrowser class >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder 
		addGroup: #versionActions with: [ :group | group 
			addActionWith: [ :action | action 
				name: 'Revert';
				description: 'Revert to this version';
				iconName: 'accept';
				action: [ :aContext | aContext doRevert ] ] ]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> addPopoverControls [
	| controlsPresenter |

	controlsPresenter := self instantiate: PulsarPopoverControlBoxPresenter.
	controlsPresenter onPulsar: [ 
		self withPopoverDo: #dismiss.
		self notifyActivateEntity: self model ].
	controlsPresenter popoverActions: self versionActions.
	headerPresenter addPresenter: controlsPresenter
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> connectPresenters [
	
	versionListPresenter 
		transmitDo: [ :aDefinition | self updateSourceWith: aDefinition ].
	versionListPresenter outputActivationPort
		transmitDo: [ :aDefinition | self doRevert ]
]

{ #category : 'api - focus' }
PulsarVersionsBrowser >> defaultKeyboardFocus [

	^ versionListPresenter
]

{ #category : 'layout' }
PulsarVersionsBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerPresenter expand: false;
		add: (SpPanedLayout newHorizontal
			positionOfSlider: 200;
			add: versionListPresenter;
			add: (SpTabLayout new 
				add: (SpScrollableLayout new 
						child: patchPresenter;
						withoutHScrollbar;
						yourself) 
					label: 'Patch';
				add: sourcePresenter label: 'Source';
				yourself);
			yourself);
		yourself
]

{ #category : 'actions' }
PulsarVersionsBrowser >> doRevert [
	"take selected version and apply it as current editor content"
	
	self  withPopoverDo: #dismiss.
	self model revertTo: versionListPresenter selectedItem
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> initializePopover: aPopoverPresenter [
	
	self addPopoverControls.
	aPopoverPresenter addShortcutWith: [ :action | action 
		shortcutKey: Character arrowDown mod3;
		action: [ 
			self withPopoverDo: #dismiss.
			self notifyActivateEntity: self model ] ]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> initializePresenters [

	self addStyle: 'dockFlyingBrowser'.
	self addStyle: 'dockVersionsFlyingBrowser'.
	
	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	versionListPresenter := self newEasyListView
		addStyle: 'stList';
		display: [ :aDefinition | aDefinition timeStamp epiceaBrowsersAsString ];
		actions: self versionActions;
		yourself.
	patchPresenter := self instantiate: SpPatchPresenter.
	patchPresenter addStyle: 'stCode'.
	
	sourcePresenter := self newCode
		editable: false;
		yourself
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model fullName;
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'private - announcing' }
PulsarVersionsBrowser >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updatePatchWith: aDefinition [
	| nextDefinition |
	nextDefinition := versionListPresenter items 
		after: aDefinition 
		ifAbsent: [ nil ].
		
	patchPresenter
		patchFrom: (nextDefinition 
			ifNotNil: [ nextDefinition sourceCode ]
			ifNil: [ '' ])
		to: aDefinition sourceCode
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	self application defer: [ 
		headerPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
			aBreadcrumb addSegment: self model title ].	
		versionListPresenter 
			items: self model versions; 
			selectFirst ]
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updateSourceCodeWith: aDefinition [
		
	sourcePresenter 
		beForMethod: aDefinition method;
		text: aDefinition sourceCode
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> updateSourceWith: aDefinition [
	
	aDefinition ifNil: [ ^ self ].
	
	self updatePatchWith: aDefinition.
	self updateSourceCodeWith: aDefinition
]

{ #category : 'initialization' }
PulsarVersionsBrowser >> versionActions [

	^ self actions actionsFor: #versionActions
]
