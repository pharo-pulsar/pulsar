Class {
	#name : 'DockBaseViewTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser',
		'presenter',
		'application'
	],
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'testing' }
DockBaseViewTest class >> isAbstract [

	^ self = DockBaseViewTest
]

{ #category : 'private' }
DockBaseViewTest >> addClass [

	^ Object << self mockClassName
		package: 'Dock-Browser-Tests';
		install
]

{ #category : 'accessing' }
DockBaseViewTest >> application [

	^ application ifNil: [ application := DockApplication new useGtkLight ]
]

{ #category : 'accessing' }
DockBaseViewTest >> classToTest [

	^ self subclassResponsibility
]

{ #category : 'private' }
DockBaseViewTest >> ensureCloseBrowser [
	
	browser ifNotNil: [ 
		browser close.
		browser := nil ]
]

{ #category : 'private' }
DockBaseViewTest >> ensureRemoveClass: aClassName [ 

	(self class environment classNamed: aClassName)
		ifNotNil: [ :aClass | aClass removeFromSystemUnlogged ].

]

{ #category : 'private' }
DockBaseViewTest >> indexOfElement: aBlock in: aCollection [
		
	aCollection withIndexDo: [ :each :index | 
		(aBlock value: each) ifTrue: [ ^ index ] ].
	
	self error: 'Should not arrive here.'
]

{ #category : 'private' }
DockBaseViewTest >> mockClass [

	^ self class environment classNamed: self mockClassName
]

{ #category : 'private' }
DockBaseViewTest >> mockClassName [

	^ #DockTestClassToRemove
]

{ #category : 'private' }
DockBaseViewTest >> newBrowser [

	^ DockBrowser newApplication: self application
]

{ #category : 'private' }
DockBaseViewTest >> openBrowser [

	browser := self newBrowser.
	browser open.
	^ browser
]

{ #category : 'private' }
DockBaseViewTest >> openBrowserOnProject [

	browser := self newBrowser.
	browser openProject: BaselineOfPerspective.
	browser open.
	^ browser
]

{ #category : 'private' }
DockBaseViewTest >> pathByName: aPath in: aCollection [ 
	| segmentName index |

	aPath ifEmpty: [ ^ #() ].

	segmentName := aPath first.	
	index := self indexOfElement: [ :each | each name = segmentName ] in: aCollection.
	^ { index }, 
		(self pathByName: aPath allButFirst in: (aCollection at: index) children)
]

{ #category : 'accessing' }
DockBaseViewTest >> presenter [

	^ presenter ifNil: [ presenter := self application new: self classToTest ]
]

{ #category : 'private' }
DockBaseViewTest >> selectClass [
	
	^ self selectPathByName: #(
		'Perspective' 
		'Dock-Browser-Tests' 
		'Uncategorized' 
		'DockTestClassToRemove')
]

{ #category : 'private' }
DockBaseViewTest >> selectPathByName: aPath [
	| listPresenter |
	
	listPresenter := browser projectView listPresenter.
	
	listPresenter selectPath: (self 
		pathByName: aPath 
		in: listPresenter roots)
]

{ #category : 'running' }
DockBaseViewTest >> tearDown [

	self ensureCloseBrowser.
	super tearDown
]

{ #category : 'private' }
DockBaseViewTest >> waitForUI [

	self waitForUI: 2
]

{ #category : 'private' }
DockBaseViewTest >> waitForUI: aNumber [

	(100 * aNumber) milliSeconds wait
]
