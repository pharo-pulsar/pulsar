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
	
	protocolList 
		transmitTo: methodList
		transform: [ :aProtocol | self methodsFor: self model protocol: aProtocol ]
]

{ #category : #private }
StBrowserClassOrganizationPresenter >> methodsFor: aClass protocol: aProtocol [

	self flag: #TODO.
	^ #()
]

{ #category : #private }
StBrowserClassOrganizationPresenter >> protocolsFor: aClass [

	aClass ifNil: [ ^ #() ].
	^ aClass protocols
]

{ #category : #initialization }
StBrowserClassOrganizationPresenter >> updatePresenter [

	protocolList items: (self protocolsFor: self model)
]
