"
Tests for the message browser presenter, covering its message list context menu.
"
Class {
	#name : 'PulsarMessageBrowserTest',
	#superclass : 'PulsarBaseViewTest',
	#instVars : [
		'messageBrowser'
	],
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarMessageBrowserTest >> classToTest [

	^ PulsarMessageBrowser
]

{ #category : 'accessing' }
PulsarMessageBrowserTest >> messageBrowser [

	^ messageBrowser ifNil: [ messageBrowser := self newMessageBrowser ]
]

{ #category : 'accessing' }
PulsarMessageBrowserTest >> messageListPresenter [

	^ self messageBrowser messageListPresenter
]

{ #category : 'accessing' }
PulsarMessageBrowserTest >> newMessageBrowser [

	^ self classToTest
		  newApplication: self application
		  model: (PulsarMessageModel
				   newEnvironment: (PvEnvironmentModel onSystem)
				   title: 'Test messages'
				   methods: {
						   Object >> #printString.
						   Object >> #printOn: })
]

{ #category : 'running' }
PulsarMessageBrowserTest >> tearDown [

	messageBrowser := nil.
	super tearDown
]

{ #category : 'tests' }
PulsarMessageBrowserTest >> testMessageListHasContextMenu [

	| messageList |
	messageList := self messageListPresenter.
	self waitForUI.
	self
		assert: messageList actions isNotNil
		description: 'The message list does not install any context menu actions'.
	self
		assert: (messageList actions allCommands anySatisfy: [ :each | each isVisible ])
		description: 'The message list context menu has no visible actions'
]
