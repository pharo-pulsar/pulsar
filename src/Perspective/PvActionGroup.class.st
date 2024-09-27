Class {
	#name : 'PvActionGroup',
	#superclass : 'CmCommandGroup',
	#instVars : [
		'priority',
		'id'
	],
	#category : 'Perspective-Command-Base',
	#package : 'Perspective',
	#tag : 'Command-Base'
}

{ #category : 'accessing' }
PvActionGroup class >> defaultPriority [

	^ 100
]

{ #category : 'instance creation' }
PvActionGroup class >> newId: aName [

	^ self new 
		id: aName;
		name: aName capitalized;
		yourself
]

{ #category : 'copying' }
PvActionGroup >> , otherGroup [

	^ PvActionGroup new 
		register: self;
		register: otherGroup;
		yourself
]

{ #category : 'accessing' }
PvActionGroup >> actions [

	^ self entries
]

{ #category : 'registering' }
PvActionGroup >> actionsFor: groupId [

	^ self groups 
		detect: [ :each | each id = groupId ]
		ifNone: [ self class new ]
]

{ #category : 'registering' }
PvActionGroup >> actionsForAll: aCollectionOfNames [

	^ aCollectionOfNames
		inject: PvActionGroup new asSpecGroup
		into: [ :all :each | | group |
			group := (self actionsFor: each).
			group hasEntries
				ifTrue: [ all register: group ].
			all ]
]

{ #category : 'converting' }
PvActionGroup >> asSpecGroup [

	^ (self decorateWith: PvSpecCommandGroup)
		iconName: #blank;
		yourself
]

{ #category : 'converting' }
PvActionGroup >> asSpecWithContext: aContext [
	| group specGroup |

	group := self copy.
	group entries: (self entries collect: [ :each | each asSpecWithContext: aContext ]).
	specGroup := group asSpecGroup.
	self configureSpecGroup: specGroup from: aContext.
	^ specGroup
]

{ #category : 'private' }
PvActionGroup >> configureSpecGroup: group from: aContext [
	| class |
	
	class := aContext class.
 	(Pragma allNamed: #perspectiveActionGroup: from: class class to: PvPresenter)
		detect: [ :each | (each argumentAt: 1) = group id ]
		ifFound: [ :aPragma | (class perform: aPragma methodSelector with: group) ]
]

{ #category : 'private' }
PvActionGroup >> entries: aCollection [

	entries := aCollection
]

{ #category : 'registering' }
PvActionGroup >> findOrRegisterGroupWithId: groupId [
	
	^ self groups 
		detect: [ :each | each id = groupId ]
		ifNone: [ 
			| newGroup |
			newGroup := self class newId: groupId.
			self register: newGroup.
			newGroup ]
]

{ #category : 'testing' }
PvActionGroup >> hasEntries [
	
	^ self entries notEmpty
]

{ #category : 'accessing' }
PvActionGroup >> id [

	^ id
]

{ #category : 'accessing' }
PvActionGroup >> id: anObject [

	id := anObject
]

{ #category : 'accessing' }
PvActionGroup >> priority [

	^ priority ifNil: [ self class defaultPriority ]
]

{ #category : 'accessing' }
PvActionGroup >> priority: anObject [

	priority := anObject
]

{ #category : 'registering' }
PvActionGroup >> registerAllActions: aCollection [ 
	
	aCollection do: [ :each | self register: each ]
]

{ #category : 'registering' }
PvActionGroup >> registerGroup: groupId with: aCollectionOfActions [
	| group |
	
	group := self findOrRegisterGroupWithId: groupId.
	group registerAllActions: (aCollectionOfActions collect: [ :each | each asPvAction ])
]
