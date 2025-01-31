Class {
	#name : 'PvAction',
	#superclass : 'CmCommand',
	#instVars : [
		'specDecorator',
		'iconComposite',
		'shortcut',
		'priority',
		'actionBlock'
	],
	#category : 'Perspective-Command-Base',
	#package : 'Perspective',
	#tag : 'Command-Base'
}

{ #category : 'accessing' }
PvAction class >> defaultPriority [

	^ 100
]

{ #category : 'accessing' }
PvAction >> action [

	^ actionBlock
]

{ #category : 'accessing' }
PvAction >> action: aBlock [

	actionBlock := aBlock
]

{ #category : 'accessing - runtime' }
PvAction >> application [

	^ context application
]

{ #category : 'converting' }
PvAction >> asPvAction [

	^ self
]

{ #category : 'converting' }
PvAction >> asSpecCommand [ 
	| command |
	
	command := self decorateWith: self specCommandClass.
	command icon: (self iconComposite 
		ifNotNil: [ :aCompositeIcon | aCompositeIcon buildOn: self application ]
		ifNil: [ self application iconNamed: #blank ]).
	self shortcut 
		ifNotNil: [ :aKeyCombination | command shortcutKey: aKeyCombination ].
		
	^ command
]

{ #category : 'converting' }
PvAction >> asSpecWithContext: aContext [

	^ self 
		context: aContext;
		asSpecCommand
]

{ #category : 'evaluating' }
PvAction >> cull: aTarget [
	"This is for compatibility with KMKeymap. Target is a SpPresenter"
	| oldContext |

	oldContext := context.
	context := aTarget asCommandContext.
	^ [ self execute ]
	ensure: [ 
		context := oldContext ]
]

{ #category : 'evaluating' }
PvAction >> cull: aTarget cull: aCaller [
	"This is for compatibility with KMKeymap. Target is a SpPresenter"

	^ self cull: aTarget
]

{ #category : 'evaluating' }
PvAction >> cull: aTarget cull: aCaller cull: aShortcut [
	"This is for compatibility with KMKeymap. Target is a SpPresenter"

	^ self cull: aTarget
]

{ #category : 'initialization' }
PvAction >> defineAction [
	"override this to define an action"
]

{ #category : 'executing' }
PvAction >> execute [
	
	actionBlock ifNil: [ ^ self ].
	actionBlock cull: self context
]

{ #category : 'testing' }
PvAction >> hasShortcut [
	
	^ self shortcut notNil
]

{ #category : 'accessing' }
PvAction >> iconComposite [

	^ iconComposite
]

{ #category : 'accessing' }
PvAction >> iconComposite: anIconComposite [

	iconComposite := anIconComposite
]

{ #category : 'accessing' }
PvAction >> iconCompositeName: aName [

	self iconComposite: (PvCompositeIcon new 
		name: aName;
		yourself)
]

{ #category : 'initialization' }
PvAction >> initialize [

	super initialize.
	self defineAction
]

{ #category : 'accessing - runtime' }
PvAction >> model [
	"All editors have a model"

	^ self context model
]

{ #category : 'accessing' }
PvAction >> presenter [

	^ self specDecorator presenter
]

{ #category : 'accessing' }
PvAction >> priority [

	^ priority ifNil: [ self class defaultPriority ]
]

{ #category : 'accessing' }
PvAction >> priority: aNumber [

	priority := aNumber
]

{ #category : 'accessing' }
PvAction >> shortcut [

	^ shortcut
]

{ #category : 'accessing' }
PvAction >> shortcut: aShortcut [

	shortcut := aShortcut
]

{ #category : 'private' }
PvAction >> specCommandClass [

	^ PvSpecCommand
]

{ #category : 'accessing - runtime' }
PvAction >> specDecorator [

	^ specDecorator
]

{ #category : 'accessing - runtime' }
PvAction >> specDecorator: aDecorator [

	specDecorator := aDecorator
]
