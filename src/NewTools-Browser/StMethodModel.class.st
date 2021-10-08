Class {
	#name : #StMethodModel,
	#superclass : #StBaseMethodModel,
	#instVars : [
		'method',
		'decorators'
	],
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #'instance creation' }
StMethodModel class >> newMethod: aMethod [ 

	^ self new 
		method: aMethod;
		yourself
]

{ #category : #accessing }
StMethodModel class >> shortSize [

	^ 30
]

{ #category : #comparing }
StMethodModel >> = other [

	^ self species = other species 
		and: [ self method = other method ]
]

{ #category : #'instance creation' }
StMethodModel >> associatedEditors [

	^ StBrowserAssociatedEditorSet with: (StBrowserMethodEditorPresenter on: self)
]

{ #category : #private }
StMethodModel >> collectDecorators [

	^ StBrowserMethodDecorator allApplingTo: self method
]

{ #category : #'accessing decorated' }
StMethodModel >> colorName [

	^ self decorated: [ :each | each colorName ] ifNone: [ nil ]
]

{ #category : #private }
StMethodModel >> decorated: aBlockOrSymbol ifNone: noneBlock [

	self decorators ifEmpty: [ ^ noneBlock value ].
	^ self decorators
		detect: [ :each | (aBlockOrSymbol value: each) notNil ]
		ifFound: [ :each | aBlockOrSymbol value: each ]
		ifNone: noneBlock
]

{ #category : #accessing }
StMethodModel >> decorators [

	^ decorators ifNil: [ decorators := self collectDecorators ]
]

{ #category : #comparing }
StMethodModel >> hash [

	^ self species hash 
		bitXor: self method hash
]

{ #category : #'accessing decorated' }
StMethodModel >> iconName [

	^ self decorated: [ :each | each iconName ] ifNone: [ #blank ]
]

{ #category : #testing }
StMethodModel >> isInstanceSide [
	
	^ self method methodClass isInstanceSide
]

{ #category : #accessing }
StMethodModel >> method [

	^ method
]

{ #category : #accessing }
StMethodModel >> method: anObject [

	method := anObject
]

{ #category : #accessing }
StMethodModel >> methodCategory [

	^ self method category
]

{ #category : #accessing }
StMethodModel >> methodClass [

	^ self method methodClass
]

{ #category : #accessing }
StMethodModel >> name [

	^ self method selector
]

{ #category : #accessing }
StMethodModel >> shortName [

	^ self name contractTo: self class shortSize
]

{ #category : #accessing }
StMethodModel >> sourceCode [
	
	^ self method sourceCode
]

{ #category : #accessing }
StMethodModel >> windowName [

	^ String streamContents: [ :stream | 
		stream 
			<< self method methodClass name 
			<< '>>'
			<< self name ]
]
