Class {
	#name : 'PulsarSystemNavigation',
	#superclass : 'SystemNavigation',
	#instVars : [
		'window',
		'environmentModel',
		'responderPresenter'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'instance creation' }
PulsarSystemNavigation class >> newWindow: aPulsarWindow [


	^ self new 
		window: aPulsarWindow;
		yourself
]

{ #category : 'accessing' }
PulsarSystemNavigation >> application [

	^ self window application
]

{ #category : 'opening' }
PulsarSystemNavigation >> browse: anObject [
	| modelClass |

	self flag: #TODO. "What happens if this is a trait? Should I use a double dispatch?"
	modelClass := anObject isCompiledMethod 
		ifTrue: [ PvMethodModel ]
		ifFalse: [ PvClassModel ].

	self window announce: (PulsarModelActivated newValue: (modelClass 
		newEnvironment: self window model environmentModel 
		entity: anObject))
]

{ #category : 'accessing' }
PulsarSystemNavigation >> browseMessageList: messageList 
	name: labelString 
	autoSelect: autoSelectString 
	refreshingBlock: aBlock [
	"Create and schedule a MessageSet browser on the message list."
	| methods popover |
	
	"Do not show trait methods"
	methods := messageList reject: [ :each| each isFromTrait ].
	
	methods ifEmpty: [
		self window inform: 'There are no ', labelString.
		^ self ].
	
	popover := self window 
		instantiate: PulsarMessageBrowser 
		on: (PulsarMessageModel 
			newEnvironment: self environmentModel
			title: labelString 
			methods: methods).
	popover notificationCenter: self notificationCenter.
	self responderPresenter insertPopover: popover
]

{ #category : 'accessing' }
PulsarSystemNavigation >> browseVersionsOf: aMethod [ 
	| popover |

	self flag: 'I have no idea if this is going to be used'.

	popover := self window 
		instantiate: PulsarVersionsBrowser 
		on: (PulsarMessageModel 
			newEnvironment: self environmentModel 
			entity: aMethod).
	popover notificationCenter: self notificationCenter.
	self responderPresenter insertPopover: popover
]

{ #category : 'accessing' }
PulsarSystemNavigation >> environmentModel [

	^ environmentModel ifNil:[ self window model environmentModel ]
]

{ #category : 'accessing' }
PulsarSystemNavigation >> environmentModel: anEnvironmentModel [

	environmentModel := anEnvironmentModel
]

{ #category : 'accessing' }
PulsarSystemNavigation >> inspect: anObject [
	| inspector |
	
	inspector := self window 
		instantiate: PulsarInspector
		on: (PulsarInspectorModel on: anObject).
	inspector notificationCenter: self notificationCenter.
	self responderPresenter insertPopover: inspector
]

{ #category : 'accessing' }
PulsarSystemNavigation >> notificationCenter [

	^ self window notificationCenter
]

{ #category : 'accessing' }
PulsarSystemNavigation >> responderPresenter [

	^ responderPresenter
]

{ #category : 'accessing' }
PulsarSystemNavigation >> responderPresenter: aPresenter [
	"this is the presenter that will be triggering the usage of some navigations... 
	 like message browser, etc.
	 Presenter needs to know the #insertPopover: message."
	
	responderPresenter := aPresenter
]

{ #category : 'accessing' }
PulsarSystemNavigation >> window [

	^ window
]

{ #category : 'accessing' }
PulsarSystemNavigation >> window: aWindow [

	window := aWindow
]
