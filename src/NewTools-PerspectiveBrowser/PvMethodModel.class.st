Class {
	#name : #PvMethodModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'decorators'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Method'
}

{ #category : #'instance creation' }
PvMethodModel class >> newMethod: aMethod [ 

	^ self new 
		method: aMethod;
		yourself
]

{ #category : #accessing }
PvMethodModel class >> shortSize [

	^ 30
]

{ #category : #comparing }
PvMethodModel >> = other [

	^ self species = other species 
		and: [ self entity = other entity ]
]

{ #category : #visiting }
PvMethodModel >> accept: aVisitor [

	^ aVisitor visitMethodModel: self
]

{ #category : #private }
PvMethodModel >> collectDecorators [

	^ StBrowserMethodDecorator allApplingTo: self entity
]

{ #category : #'accessing - decorated' }
PvMethodModel >> colorName [

	^ self decorated: [ :each | each colorName ] ifNone: [ nil ]
]

{ #category : #compiling }
PvMethodModel >> compile: aString notifying: requestor [

	self sourceCode = aString ifTrue: [ ^ self ].

	self methodClass 
		compile: aString
		classified: self methodCategory
		notifying: requestor
]

{ #category : #private }
PvMethodModel >> decorated: aBlockOrSymbol ifNone: noneBlock [

	self decorators ifEmpty: [ ^ noneBlock value ].
	^ self decorators
		detect: [ :each | (aBlockOrSymbol value: each) notNil ]
		ifFound: [ :each | aBlockOrSymbol value: each ]
		ifNone: noneBlock
]

{ #category : #accessing }
PvMethodModel >> decorators [

	^ decorators ifNil: [ decorators := self collectDecorators ]
]

{ #category : #'accessing - editor' }
PvMethodModel >> editorClass [

	^ PvMethodEditorPresenter
]

{ #category : #comparing }
PvMethodModel >> hash [

	^ self species hash 
		bitXor: self method hash
]

{ #category : #'accessing - decorated' }
PvMethodModel >> iconName [

	^ self decorated: [ :each | each iconName ] ifNone: [ #blank ]
]

{ #category : #testing }
PvMethodModel >> isInstanceSide [
	
	^ self entity methodClass isInstanceSide
]

{ #category : #accessing }
PvMethodModel >> methodCategory [

	^ self entity category
]

{ #category : #accessing }
PvMethodModel >> methodClass [

	^ self entity methodClass
]

{ #category : #accessing }
PvMethodModel >> name [

	^ self entity selector
]

{ #category : #accessing }
PvMethodModel >> shortName [

	^ self name contractTo: self class shortSize
]

{ #category : #accessing }
PvMethodModel >> sourceCode [
	
	^ self entity sourceCode
]

{ #category : #accessing }
PvMethodModel >> windowIconName [
	
	^ #scriptManager
]

{ #category : #accessing }
PvMethodModel >> windowTitle [

	^ String streamContents: [ :stream | 
		stream 
			<< self entity methodClass name 
			<< '>>'
			<< self name ]
]
