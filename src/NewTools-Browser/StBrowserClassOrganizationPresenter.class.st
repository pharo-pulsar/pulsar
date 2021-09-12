Class {
	#name : #StBrowserClassOrganizationPresenter,
	#superclass : #StBrowserModelPresenter,
	#instVars : [
		'protocolList',
		'methodList'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #initialization }
StBrowserClassOrganizationPresenter >> initializePresenters [

	self layout: (SpPanedLayout newLeftToRight
		add: (protocolList := self newList);
		add: (methodList := self newList);
		yourself).
	
	protocolList display: [ :aProtocolModel | aProtocolModel name ]. 
	methodList display: [ :aMethodModel | aMethodModel name ]. 
	
	protocolList 
		transmitTo: methodList
		transform: [ :aProtocolModel | self methodsFor: aProtocolModel ]
]

{ #category : #accessing }
StBrowserClassOrganizationPresenter >> methodsFor: aProtocolModel [

	aProtocolModel ifNil: [ ^ #() ].
	^ aProtocolModel methods
]

{ #category : #accessing }
StBrowserClassOrganizationPresenter >> protocolsFor: aClassModel [ 
	
	aClassModel ifNil: [ ^ #() ].
	^ aClassModel protocols
]

{ #category : #initialization }
StBrowserClassOrganizationPresenter >> updatePresenter [

	protocolList items: (self protocolsFor: self model)
]
