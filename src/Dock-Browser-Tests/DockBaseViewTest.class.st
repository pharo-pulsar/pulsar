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

{ #category : 'accessing' }
DockBaseViewTest >> presenter [

	^ presenter ifNil: [ presenter := self application new: self classToTest ]
]

{ #category : 'running' }
DockBaseViewTest >> tearDown [

	self ensureCloseBrowser.
	super tearDown
]
