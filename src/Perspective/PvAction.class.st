Class {
	#name : #PvAction,
	#superclass : #CmCommand,
	#instVars : [
		'specDecorator',
		'iconComposite',
		'shortcut',
		'toolbarGroup',
		'menuGroup',
		'priority'
	],
	#category : #'Perspective-Command-Base'
}

{ #category : #accessing }
PvAction class >> defaultPriority [

	^ 100
]

{ #category : #'accessing - runtime' }
PvAction >> application [

	^ context application
]

{ #category : #converting }
PvAction >> asPvAction [

	^ self
]

{ #category : #converting }
PvAction >> asSpecCommand [ 
	| command |
	
	command := self decorateWith: PvSpecCommand.
	command icon: (self iconComposite 
		ifNotNil: [ :aCompositeIcon | aCompositeIcon buildOn: self application ]
		ifNil: [ self application iconNamed: #blank ]).
	self shortcut 
		ifNotNil: [ :aKeyCombination | command shortcutKey: aKeyCombination ].
		
	^ command
]

{ #category : #converting }
PvAction >> asSpecWithContext: aContext [

	^ self 
		context: aContext;
		asSpecCommand
]

{ #category : #evaluating }
PvAction >> cull: aTarget [
	"This is for compatibility with KMKeymap. Target is a SpPresenter"
	| oldContext |

	oldContext := context.
	context := aTarget asCommandContext.
	^ [ self execute ]
	ensure: [ 
		context := oldContext ]
]

{ #category : #evaluating }
PvAction >> cull: aTarget cull: aCaller [
	"This is for compatibility with KMKeymap. Target is a SpPresenter"

	^ self cull: aTarget
]

{ #category : #evaluating }
PvAction >> cull: aTarget cull: aCaller cull: aShortcut [
	"This is for compatibility with KMKeymap. Target is a SpPresenter"

	^ self cull: aTarget
]

{ #category : #initialization }
PvAction >> defineAction [

	self subclassResponsibility
]

{ #category : #testing }
PvAction >> hasShortcut [
	
	^ self shortcut notNil
]

{ #category : #accessing }
PvAction >> iconComposite [

	^ iconComposite
]

{ #category : #accessing }
PvAction >> iconComposite: anIconComposite [

	iconComposite := anIconComposite
]

{ #category : #accessing }
PvAction >> iconCompositeName: aName [

	self iconComposite: (PvCompositeIcon new 
		name: aName;
		yourself)
]

{ #category : #initialization }
PvAction >> initialize [

	super initialize.
	self defineAction
]

{ #category : #testing }
PvAction >> isVisibleInMenu [

	^ self menuGroup notNil
]

{ #category : #accessing }
PvAction >> menuGroup [

	^ menuGroup
]

{ #category : #accessing }
PvAction >> menuGroup: aSymbol [

	menuGroup := aSymbol
]

{ #category : #'accessing - runtime' }
PvAction >> model [
	"All editors have a model"

	^ self context model
]

{ #category : #accessing }
PvAction >> priority [

	^ priority ifNil: [ self class defaultPriority ]
]

{ #category : #accessing }
PvAction >> priority: aNumber [

	priority := aNumber
]

{ #category : #accessing }
PvAction >> shortcut [

	^ shortcut
]

{ #category : #accessing }
PvAction >> shortcut: aShortcut [

	shortcut := aShortcut
]

{ #category : #'accessing - runtime' }
PvAction >> specDecorator [

	^ specDecorator
]

{ #category : #'accessing - runtime' }
PvAction >> specDecorator: aDecorator [

	specDecorator := aDecorator
]

{ #category : #accessing }
PvAction >> toolbarGroup [

	^ toolbarGroup
]

{ #category : #accessing }
PvAction >> toolbarGroup: aSymbol [

	toolbarGroup := aSymbol
]
