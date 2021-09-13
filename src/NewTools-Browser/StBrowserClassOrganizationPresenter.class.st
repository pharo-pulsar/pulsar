Class {
	#name : #StBrowserClassOrganizationPresenter,
	#superclass : #StBrowserPanelPresenter,
	#instVars : [
		'protocolList',
		'methodList'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #'private - consuming' }
StBrowserClassOrganizationPresenter >> consumeMethodFromPath: path [ 
	
	methodList selectItem: path first.
	^ path allButFirst
]

{ #category : #'accessing - selecting' }
StBrowserClassOrganizationPresenter >> consumePath: aPath [
	| path |

	path := self consumeProtocolFromPath: aPath.
	path := self consumeMethodFromPath: path.
	
	^ path
	
]

{ #category : #'private - consuming' }
StBrowserClassOrganizationPresenter >> consumeProtocolFromPath: path [

	path ifEmpty: [ ^ #() ].
	
	protocolList selectItem: path first.
	^ path allButFirst
]

{ #category : #transmission }
StBrowserClassOrganizationPresenter >> defaultOutputPort [

	^ self outputMethodSelectionPort
]

{ #category : #initialization }
StBrowserClassOrganizationPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		add: (protocolList := self newList);
		add: (methodList := self newList);
		yourself).
	
	protocolList 
		display: [ :aProtocolModel | aProtocolModel name ];
		displayIcon: [ :aProtocolModel | self iconNamed: aProtocolModel iconName ]. 
	methodList 
		display: [ :aMethodModel | aMethodModel name ];
		displayIcon: [ :aMethodModel | self iconNamed: aMethodModel iconName ]. 
	
	protocolList 
		transmitTo: methodList
		transform: [ :aProtocolModel | self methodsFor: aProtocolModel ]
]

{ #category : #accessing }
StBrowserClassOrganizationPresenter >> methodsFor: aProtocolModel [

	aProtocolModel ifNil: [ ^ #() ].
	^ aProtocolModel methods
]

{ #category : #transmission }
StBrowserClassOrganizationPresenter >> outputMethodSelectionPort [

	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ methodList ];
		yourself
]

{ #category : #transmission }
StBrowserClassOrganizationPresenter >> outputProtocolSelectionPort [

	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ protocolList ];
		yourself
]

{ #category : #accessing }
StBrowserClassOrganizationPresenter >> protocolsFor: aClassModel [ 
	
	aClassModel ifNil: [ ^ #() ].
	^ aClassModel protocols
]

{ #category : #accessing }
StBrowserClassOrganizationPresenter >> selectedItem [
	
	^ methodList selectedItem
]

{ #category : #initialization }
StBrowserClassOrganizationPresenter >> updatePresenter [

	protocolList items: (self protocolsFor: self model)
]

{ #category : #events }
StBrowserClassOrganizationPresenter >> whenMethodSelectionChangedDo: aBlock [

	methodList whenSelectionChangedDo: aBlock
]

{ #category : #events }
StBrowserClassOrganizationPresenter >> whenProtocolSelectionChangedDo: aBlock [

	protocolList whenSelectionChangedDo: aBlock
]
