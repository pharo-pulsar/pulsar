Class {
	#name : 'PulsarRepositoryPatchPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTNotificationCenter',
	#classTraits : 'SpTModel classTrait + PulsarTNotificationCenter classTrait',
	#instVars : [
		'headerPresenter',
		'patchPresenter',
		'summaryPresenter',
		'model',
		'notificationCenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Editor',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Editor'
}

{ #category : 'layout' }
PulsarRepositoryPatchPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		vAlignStart;
		add: headerPresenter;
		add: patchPresenter;
		yourself
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> initializePresenters [

	self addStyle: 'pulsarRepositoryPatch'.

	headerPresenter := self instantiate: PulsarEditorToolbarPresenter.
	summaryPresenter := self newLabel 
		addStyle: 'summary';
		useMarkup.
	headerPresenter addPresenter: summaryPresenter.
	
	patchPresenter := (self instantiate: self patchPresenterClass)
		styleScheme: self application styleScheme;
		syntaxHighlightTheme: self application syntaxHighlightTheme;
		yourself	
]

{ #category : 'accessing' }
PulsarRepositoryPatchPresenter >> notificationCenter [

	^ notificationCenter
]

{ #category : 'accessing' }
PulsarRepositoryPatchPresenter >> notificationCenter: anAnnouncer [

	self basicNotificationCenter: anAnnouncer.
	self model ifNotNil: [ self updatePresenter ]
]

{ #category : 'actions' }
PulsarRepositoryPatchPresenter >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> patchPresenterClass [

	^ SpPatchPresenter
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> registerToBrowser: aPulsarBrowser [
	 
	logger trace: aPulsarBrowser.

	"take the announcer of the dock to broadcast what happens"
	self notificationCenter: aPulsarBrowser announcer.
]

{ #category : 'initialization' }
PulsarRepositoryPatchPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	headerPresenter updateBreadcrumbWith: [ :aBreadcrumb |
		PulsarDiffBreadcrumbBuilder new
			breadcrumb: aBreadcrumb;
			diffNode: self model;
			whenActivatedDo: [ :entityModel | self notifyActivateEntity: entityModel ];
			buildFrom: self model nodeDefinition ].

	summaryPresenter label: self model summary.

	patchPresenter patch: self model patch
]
