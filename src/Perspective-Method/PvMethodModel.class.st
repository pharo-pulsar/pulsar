Class {
	#name : #PvMethodModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'decorators'
	],
	#category : #'Perspective-Method-Model'
}

{ #category : #'instance creation' }
PvMethodModel class >> newMethod: aMethod [ 

	^ self new 
		method: aMethod;
		yourself
]

{ #category : #visiting }
PvMethodModel >> accept: aVisitor [

	^ aVisitor visitMethodModel: self
]

{ #category : #converting }
PvMethodModel >> asClassModel [
	
	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self methodClass
]

{ #category : #converting }
PvMethodModel >> asOutlineClassModel [
	
	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self methodClass
]

{ #category : #private }
PvMethodModel >> collectDecorators [

	^ StBrowserMethodDecorator allApplingTo: self entity
]

{ #category : #'accessing - decorated' }
PvMethodModel >> colorName [

	^ self 
		decorated: [ :each | each colorName ] 
		ifNone: [ nil ]
]

{ #category : #compiling }
PvMethodModel >> compile: aString notifying: requestor [
	| selector |

	self sourceCode = aString ifTrue: [ ^ self ].

	[
		selector := self entity methodClass 
			compile: aString
			classified: self methodCategory
			notifying: requestor.
		self entity: self entity methodClass >> selector ]
	on: OCSemanticWarning 
	do: [ :w | 
		w resume: (w accept: PvMethodCompilationVisitor new) ]
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

	^ PvMethodEditorView
]

{ #category : #accessing }
PvMethodModel >> fullName [

	^ String streamContents: [ :stream | 
		stream 
			<< self methodClassName
			<< '>>'
			<< self name ]
]

{ #category : #'accessing - decorated' }
PvMethodModel >> iconName [

	^ self 
		decorated: [ :each | each iconName ] 
		ifNone: [ #blank ]
]

{ #category : #testing }
PvMethodModel >> includesClassModel [

	^ true
]

{ #category : #testing }
PvMethodModel >> isInstanceSide [
	
	^ self entity methodClass isInstanceSide
]

{ #category : #testing }
PvMethodModel >> isOutlineClassEntity [

	^ true
]

{ #category : #testing }
PvMethodModel >> isTestMethod [
	
	^ self entity isTestMethod
]

{ #category : #accessing }
PvMethodModel >> methodCategory [

	^ self entity category
]

{ #category : #accessing }
PvMethodModel >> methodClass [

	^ self entity methodClass instanceSide
]

{ #category : #accessing }
PvMethodModel >> methodClassName [

	^ self entity methodClass name
]

{ #category : #accessing }
PvMethodModel >> name [

	^ self entity selector
]

{ #category : #accessing }
PvMethodModel >> protocol [

	^ self entity protocol
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
PvMethodModel >> spotterTitle [

	^ String streamContents: [ :stream |
		stream << self windowTitle << ' (' << self methodClass name << ')' ]
]

{ #category : #accessing }
PvMethodModel >> windowIconName [

	^ 'method' "#scriptManager"
]

{ #category : #accessing }
PvMethodModel >> windowTitle [

	^ self shortName
]
