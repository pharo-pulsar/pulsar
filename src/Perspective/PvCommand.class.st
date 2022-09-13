"
A base command for perspectives. 


# Design of commands for perspectives

In general, in Pharo we prefer to use lightway commands: commands define actions which are later implemented in the context of the command, and the command execution simply executes a delegation.
**HOWEVER**, perspective commands behave differently: We have designed perspectives to allow fast switching of views (See `PvPerspectiveView`), views that can be refering to the same element and because of that they have the same set of actions available.
In perspective views and editors it would be cumbersome to define once and again same set of actions on each new view and because of that we have decided to change the general recommendation: perspective commands will be heavy weight, including as much logic as possible to solve the action.  
"
Class {
	#name : #PvCommand,
	#superclass : #CmCommand,
	#instVars : [
		'specDecorator'
	],
	#category : #'Perspective-Command'
}

{ #category : #accessing }
PvCommand class >> allCommands [

	^ (self allSubclasses 
		reject: [ :each | each isAbstract ])
		sorted: #defaultPriority ascending
]

{ #category : #accessing }
PvCommand class >> allMenuCommands [

	^ (self allSubclasses 
		reject: [ :each | 
			each isAbstract
			or: [ each isVisibleInMenu not ] ])
		sorted: #defaultPriority ascending
]

{ #category : #accessing }
PvCommand class >> allToolbarCommands [

	^ (self allSubclasses 
		reject: [ :each | 
			each isAbstract 
			or: [ each isVisibleInToolbar not ] ])
		sorted: #defaultPriority ascending
]

{ #category : #'private - building' }
PvCommand class >> buildGroup: aGroupOrCollection commands: aCollection on: aContext [
	| groups rootGroup |
	
	groups := aGroupOrCollection isSymbol 
		ifTrue: [ { aGroupOrCollection } ] 
		ifFalse: [ aGroupOrCollection ].
	
	rootGroup := CmCommandGroup new asSpecGroup.
	rootGroup beRoot.
	groups do: [ :eachGroup | | group |
		group := self commandGroupForGroup: eachGroup.
		(self commandsInGroup: eachGroup) 
			do: [ :each | group register: (each forSpecContext: aContext) ].
		rootGroup register: group ].
	
	^ rootGroup
]

{ #category : #'building - menus' }
PvCommand class >> buildMenu: aGroupOrCollection on: aContext [

	^ self 
		buildGroup: aGroupOrCollection 
		commands: self allMenuCommands
		on: aContext
]

{ #category : #'building - menus' }
PvCommand class >> buildMenuOn: aContext [

	^ self 
		buildGroup: #default
		commands: self allMenuCommands
		on: aContext
]

{ #category : #'building - toolbars' }
PvCommand class >> buildToolbar: aGroupOrCollection on: aContext [

	^ self 
		buildGroup: aGroupOrCollection 
		commands: self allToolbarCommands
		on: aContext
]

{ #category : #'building - toolbars' }
PvCommand class >> buildToolbarOn: aContext [

	^ self 
		buildGroup: #default
		commands: self allToolbarCommands
		on: aContext
]

{ #category : #'default - groups' }
PvCommand class >> commandGroupAction [
	<commandGroup: #action>
	
	^ (CmCommandGroup named: 'Actions') asSpecGroup
		beDisplayedAsGroup;
		yourself
]

{ #category : #'private - building' }
PvCommand class >> commandGroupForGroup: aSymbol [

	^ (Pragma allNamed: #commandGroup: from: self class to: PvCommand)
		detect: [ :each | (each argumentAt: 1) = aSymbol ]
		ifFound: [ :aPragma | self perform: aPragma methodSelector  ]
		ifNone: [ (CmCommandGroup named: aSymbol asString capitalized) asSpecGroup ]
]

{ #category : #'private - building' }
PvCommand class >> commandsInGroup: aGroup [

	^ (self allCommands
		select: [ :each | each groups includes: aGroup ])
		sorted: #defaultPriority ascending	
]

{ #category : #default }
PvCommand class >> defaultIconComposite [

	^ self defaultIconName ifNotNil: [ 
		PvCompositeIcon new 
			name: self defaultIconName;
			yourself ]
]

{ #category : #default }
PvCommand class >> defaultIconName [
		
	^ nil
]

{ #category : #default }
PvCommand class >> defaultPriority [

	^ 100
]

{ #category : #default }
PvCommand class >> defaultShortcut [

	^ nil
]

{ #category : #default }
PvCommand class >> groups [

	^ #default
]

{ #category : #testing }
PvCommand class >> isAbstract [

	^ self = PvCommand
]

{ #category : #testing }
PvCommand class >> isVisibleInMenu [

	^ true
]

{ #category : #testing }
PvCommand class >> isVisibleInToolbar [

	^ false
]

{ #category : #accessing }
PvCommand >> application [

	^ context application
]

{ #category : #converting }
PvCommand >> asSpecCommand [ 
	| command |
	
	command := self decorateWith: PvSpecCommand.
	 self iconComposite 
		ifNotNil: [ :aCompositeIcon | command icon: (aCompositeIcon buildOn: self application) ].
	self shortcut 
		ifNotNil: [ :aKeyCombination | command shortcutKey: aKeyCombination ].
		
	^ command
]

{ #category : #accessing }
PvCommand >> iconComposite [

	^ self class defaultIconComposite
]

{ #category : #accessing }
PvCommand >> model [
	"All editors have a model"

	^ self context model
]

{ #category : #accessing }
PvCommand >> shortcut [

	^ self class defaultShortcut
]

{ #category : #accessing }
PvCommand >> specDecorator [

	^ specDecorator
]

{ #category : #accessing }
PvCommand >> specDecorator: aDecorator [

	specDecorator := aDecorator
]
