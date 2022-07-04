Class {
	#name : #PvCommand,
	#superclass : #CmCommand,
	#category : #'Perspective-Command'
}

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
PvCommand class >> defaultShortcut [

	^ nil
]

{ #category : #accessing }
PvCommand >> application [

	^ context application
]

{ #category : #converting }
PvCommand >> asSpecCommand [ 
	| command |
	
	command := (self decorateWith: PvSpecCommand) 
		icon: (self iconComposite buildOn: self application);
		yourself.
		
	self shortcut 
		ifNotNil: [ :keyCombination | command shortcutKey: keyCombination ].
		
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
