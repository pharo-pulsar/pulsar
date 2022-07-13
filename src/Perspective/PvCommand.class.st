Class {
	#name : #PvCommand,
	#superclass : #CmCommand,
	#category : #'Perspective-Command'
}

{ #category : #accessing }
PvCommand class >> allCommands [

	^ (self allSubclasses 
		reject: [ :each | each isAbstract ])
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

{ #category : #'building - toolbars' }
PvCommand class >> buildToolbar: aGroupOrCollection commands: aCollection on: aContext [
	| groups rootGroup |
	
	groups := aGroupOrCollection isSymbol 
		ifTrue: [ { aGroupOrCollection } ] 
		ifFalse: [ aGroupOrCollection ].
	
	rootGroup := CmCommandGroup new asSpecGroup.
	rootGroup beRoot.
	groups do: [ :eachGroup | | group |
		group := (CmCommandGroup named: eachGroup) asSpecGroup.
		(self toolbarCommandsGroup: eachGroup) 
			do: [ :each | group register: (each forSpecContext: aContext) ].
		rootGroup register: group ].
	
	^ rootGroup
]

{ #category : #'building - toolbars' }
PvCommand class >> buildToolbar: aGroupOrCollection on: aContext [

	^ self 
		buildToolbar: aGroupOrCollection 
		commands: self allToolbarCommands
		on: aContext
]

{ #category : #'building - toolbars' }
PvCommand class >> buildToolbarOn: aContext [

	^ self 
		buildToolbar: #default
		commands: self allToolbarCommands
		on: aContext
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
PvCommand class >> defaultToolbarGroup [

	^ #default
]

{ #category : #testing }
PvCommand class >> isAbstract [

	^ self = PvCommand
]

{ #category : #testing }
PvCommand class >> isVisibleInToolbar [

	^ false
]

{ #category : #accessing }
PvCommand class >> toolbarCommandsGroup: aGroup [

	^ (self allSubclasses 
		select: [ :each | 
			each isAbstract not 
			and: [ each isVisibleInToolbar
			and: [ each defaultToolbarGroup = aGroup ] ] ])
		sorted: #defaultPriority ascending	
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
PvCommand >> shortcut [

	^ self class defaultShortcut
]
