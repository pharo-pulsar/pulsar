Class {
	#name : 'DockSystemNavigation',
	#superclass : 'SystemNavigation',
	#instVars : [
		'window',
		'codePresenter',
		'environmentModel'
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
		^ self window inform: 'There are no ', String cr, labelString ].
	
	popover := self window 
		instantiate: DockMessageBrowser 
		on: (DockMessageModel 
			newEnvironment: self environmentModel
			title: labelString 
			methods: methods).
	popover notificationCenter: self notificationCenter.
	self codePresenter insertPopoverAfterCurrentSelection: popover.
	
	"self application tools messageList new
		messages: methods; 
		title: labelString;
		""autoSelect: autoSelectString;""
		refreshingBlock: aBlock"
	
	"self code  "
]

{ #category : 'accessing' }
DockSystemNavigation >> codePresenter [

	^ codePresenter
]

{ #category : 'accessing' }
DockSystemNavigation >> codePresenter: aCodePresenter [
	"this is the presenter that will be triggering the usage of some navigations... like message 
	 browser, etc."
	
	codePresenter := aCodePresenter
]

{ #category : 'accessing' }
DockSystemNavigation >> environmentModel [

	^ self window model environmentModel
]

{ #category : 'accessing' }
DockSystemNavigation >> notificationCenter [

	^ self window notificationCenter
]

{ #category : 'accessing' }
DockSystemNavigation >> window [

	^ window
]

{ #category : 'accessing' }
DockSystemNavigation >> window: aWindow [

	window := aWindow
]
