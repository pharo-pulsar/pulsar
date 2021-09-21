Class {
	#name : #StMethodModel,
	#superclass : #StBaseModel,
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

{ #category : #private }
StMethodModel >> collectDecorators [

	^ StBrowserMethodDecorator allApplingTo: self method
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

{ #category : #accessing }
StMethodModel >> iconName [

	self decorators ifEmpty: [ ^ #blank ].
	^ self decorators  
		detect: [ :each | each iconName notNil ]
		ifFound: [ :each | each iconName ]
		ifNone: [ #blank ]
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
StMethodModel >> name [

	^ self method selector
]

{ #category : #'instance creation' }
StMethodModel >> newEditors [

	^ { StBrowserMethodEditorPresenter on: self }
]

{ #category : #accessing }
StMethodModel >> shortName [

	^ self name contractTo: self class shortSize
]

{ #category : #accessing }
StMethodModel >> sourceCode [
	
	^ self method sourceCode
]

{ #category : #default }
StMethodModel >> windowName [

	^ String streamContents: [ :stream | 
		stream 
			<< self method methodClass name 
			<< '>>'
			<< self name ]
]
