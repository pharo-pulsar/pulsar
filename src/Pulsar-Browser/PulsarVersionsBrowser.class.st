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

{ #category : 'private - definitions' }
PulsarVersionsBrowser >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #versionActions with: [ :group | 
		group addActionWith: [ :action | action 
			name: 'Revert';
			description: 'Revert to this version';
			iconName: 'accept';
			action: [ self doRevert ] ] ]
]

{ #category : 'private - definitions' }
PulsarVersionsBrowser >> defineExtraActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #extraActions with: [ :group | group 
		addActionWith: [ :action | action 
			name: 'Fetch remote versions';
			description: 'Fetch remote versions';
			iconName: 'fetch';
			actionEnabled: [ self hasRemoteVersions ];
			action: [ self doFetchRemoteVersionsCommand: action ] ] ]
]

{ #category : 'private - actions' }
PulsarVersionsBrowser >> doFetchRemoteVersionsCommand: anAction [
	| repositories popover |
	
	repositories := self model includingRepositories.
	repositories size > 1 ifFalse: [
		self doFetchRemoteVersionsOnRepository: repositories anyOne.
		^ self ].

	self flag: #TODO. "I need a choose popover (like the request popover)" 
	popover := self newPopover.
	popover presenter: ((self instantiate: PulsarSelectDialog)
		items: repositories;
		display: #name;
		yourself).
	popover relativeTo: anAction presenter.
	popover popup
]

{ #category : 'private - actions' }
PulsarVersionsBrowser >> doFetchRemoteVersionsOnRepository: aRepositoryModel [

	self withWindowDo: [ :aWindow |
		aWindow scheduleJob: [ 
			self model fetchRemoteVersionsOn: aRepositoryModel.
			self updatePresenter ] ]
]

{ #category : 'actions' }
PulsarVersionsBrowser >> doRevert [
	"take selected version and apply it as current editor content"
	
	self  withPopoverDo: #dismiss.
	self model revertTo: versionListPresenter selectedItem
]

{ #category : 'private - testing' }
PulsarVersionsBrowser >> hasRemoteVersions [

	self model ifNotNil: [ ^ self model hasValidRemote ].
	
	^ false
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

	self addStyle: 'pulsarFlyingBrowser'.
	self addStyle: 'pulsarVersionsFlyingBrowser'.
	
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

	^ self actions actionsForAll: #(versionActions extraActions)
]
