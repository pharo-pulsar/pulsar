Class {
	#name : 'DockSystemNavigation',
	#superclass : 'SystemNavigation',
	#instVars : [
		'window',
		'environmentModel',
		'responderPresenter'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'instance creation' }
DockSystemNavigation class >> newWindow: aDockWindow [


	^ self new 
		window: aDockWindow;
		yourself
]

{ #category : 'accessing' }
DockSystemNavigation >> application [

	^ self window application
]

{ #category : 'opening' }
DockSystemNavigation >> browse: anObject [
	| modelClass |

	self flag: #TODO. "What happens if this is a trait? Should I use a double dispatch?"
	modelClass := anObject isCompiledMethod 
		ifTrue: [ PvMethodModel ]
		ifFalse: [ PvClassModel ].

	self window announce: (DockModelActivated newValue: (modelClass 
		newEnvironment: self window model environmentModel 
		entity: anObject))
]

{ #category : 'accessing' }
DockSystemNavigation >> browseMessageList: messageList 
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
		instantiate: DockMessageBrowser 
		on: (DockMessageModel 
			newEnvironment: self environmentModel
			title: labelString 
			methods: methods).
	popover notificationCenter: self notificationCenter.
	self responderPresenter insertPopover: popover
]

{ #category : 'accessing' }
DockSystemNavigation >> browseVersionsOf: aMethod [ 
	| popover |

	self flag: 'I have no idea if this is going to be used'.

	popover := self window 
		instantiate: DockVersionsBrowser 
		on: (DockMessageModel 
			newEnvironment: self environmentModel 
			entity: aMethod).
	popover notificationCenter: self notificationCenter.
	self responderPresenter insertPopover: popover
]

{ #category : 'accessing' }
DockSystemNavigation >> environmentModel [

	^ self window model environmentModel
]

{ #category : 'accessing' }
DockSystemNavigation >> inspect: anObject [
	| inspector |
	
	inspector := self window 
		instantiate: DockInspector
		on: (DockInspectorModel on: anObject).
	inspector notificationCenter: self notificationCenter.
	self responderPresenter insertPopover: inspector
]

{ #category : 'accessing' }
DockSystemNavigation >> notificationCenter [

	^ self window notificationCenter
]

{ #category : 'accessing' }
DockSystemNavigation >> responderPresenter [

	^ responderPresenter
]

{ #category : 'accessing' }
DockSystemNavigation >> responderPresenter: aPresenter [
	"this is the presenter that will be triggering the usage of some navigations... 
	 like message browser, etc.
	 Presenter needs to know the #insertPopover: message."
	
	responderPresenter := aPresenter
]

{ #category : 'accessing' }
DockSystemNavigation >> window [

	^ window
]

{ #category : 'accessing' }
DockSystemNavigation >> window: aWindow [

	window := aWindow
]
