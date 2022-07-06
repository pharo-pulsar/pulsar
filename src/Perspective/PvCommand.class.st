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

{ #category : #testing }
PvCommand class >> isAbstract [

	^ self = PvCommand
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
