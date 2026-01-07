Class {
	#name : 'PulsarBaseViewTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser',
		'presenter',
		'application'
	],
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'testing' }
PulsarBaseViewTest class >> isAbstract [

	^ self = PulsarBaseViewTest
]

{ #category : 'private' }
PulsarBaseViewTest >> addClass [

	^ Object << self mockClassName
		package: 'Pulsar-Browser-Tests';
		install
]

{ #category : 'accessing' }
PulsarBaseViewTest >> application [

	^ application ifNil: [ application := PulsarApplication new ]
]

{ #category : 'accessing' }
PulsarBaseViewTest >> classToTest [

	^ self subclassResponsibility
]

{ #category : 'private' }
PulsarBaseViewTest >> ensureCloseBrowser [
	
	browser ifNotNil: [ 
		browser close.
		browser := nil ]
]

{ #category : 'private' }
PulsarBaseViewTest >> ensureRemoveClass: aClassName [ 

	(self class environment classNamed: aClassName)
		ifNotNil: [ :aClass | aClass removeFromSystemUnlogged ].

]

{ #category : 'private' }
PulsarBaseViewTest >> ensureRemoveMethod: aSelector [ 

	self class methodDict
		at: aSelector
		ifPresent: [ :aMethod | aMethod removeFromSystem ]
]

{ #category : 'private' }
PulsarBaseViewTest >> indexOfElement: aBlock in: aCollection [
		
	aCollection withIndexDo: [ :each :index | 
		(aBlock value: each) ifTrue: [ ^ index ] ].
	
	self error: 'Should not arrive here.'
]

{ #category : 'private' }
PulsarBaseViewTest >> mockClass [

	^ self class environment classNamed: self mockClassName
]

{ #category : 'private' }
PulsarBaseViewTest >> mockClassName [

	^ #PulsarTestClassToRemove
]

{ #category : 'private' }
PulsarBaseViewTest >> newBrowser [

	^ PulsarBrowser newApplication: self application
]

{ #category : 'private' }
PulsarBaseViewTest >> openBrowser [

	browser := self newBrowser.
	browser open.
	^ browser
]

{ #category : 'private' }
PulsarBaseViewTest >> openBrowserOnProject [

	browser := self newBrowser.
	browser openProject: BaselineOfPulsar.
	browser open.
	^ browser
]

{ #category : 'private' }
PulsarBaseViewTest >> pathByName: aPath in: aCollection [ 
	| segmentName index |

	aPath ifEmpty: [ ^ #() ].

	segmentName := aPath first.	
	index := self indexOfElement: [ :each | each name = segmentName ] in: aCollection.
	^ { index }, 
		(self pathByName: aPath allButFirst in: (aCollection at: index) children)
]

{ #category : 'accessing' }
PulsarBaseViewTest >> presenter [

	^ presenter ifNil: [ presenter := self application new: self classToTest ]
]

{ #category : 'private' }
PulsarBaseViewTest >> selectClass [
	
	^ self selectPathByName: #(
		'Perspective' 
		'Pulsar-Browser-Tests' 
		'Uncategorized' 
		'PulsarTestClassToRemove')
]

{ #category : 'private' }
PulsarBaseViewTest >> selectPathByName: aPath [
	| listPresenter |
	
	listPresenter := browser projectView listPresenter.
	
	listPresenter selectPath: (self 
		pathByName: aPath 
		in: listPresenter roots)
]

{ #category : 'running' }
PulsarBaseViewTest >> tearDown [

	self ensureCloseBrowser.
	super tearDown
]

{ #category : 'private' }
PulsarBaseViewTest >> waitForUI [

	self waitForUI: 2
]

{ #category : 'private' }
PulsarBaseViewTest >> waitForUI: aNumber [

	(100 * aNumber) milliSeconds wait
]
