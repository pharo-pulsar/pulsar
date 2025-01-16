Class {
	#name : 'DockMethodEditorTest',
	#superclass : 'DockEditorTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'tests' }
DockMethodEditorTest >> addClass [

	^ Object << #DockTestClassToRemove
		package: 'Dock-Browser-Tests';
		install
]

{ #category : 'accessing' }
DockMethodEditorTest >> classToTest [

	^ DockClassEditor
]

{ #category : 'running' }
DockMethodEditorTest >> ensureRemoveClass: aClassName [ 

	(self class environment classNamed: aClassName)
		ifNotNil: [ :aClass | aClass removeFromSystemUnlogged ].

]

{ #category : 'accessing' }
DockMethodEditorTest >> indexOfElement: aBlock in: aCollection [
		
	aCollection withIndexDo: [ :each :index | 
		(aBlock value: each) ifTrue: [ ^ index ] ].
	
	self error: 'Should not arrive here.'
]

{ #category : 'accessing' }
DockMethodEditorTest >> pathByName: aPath in: aCollection [ 
	| segmentName index |

	aPath ifEmpty: [ ^ #() ].

	segmentName := aPath first.	
	index := self indexOfElement: [ :each | each name = segmentName ] in: aCollection.
	^ { index }, 
		(self pathByName: aPath allButFirst in: (aCollection at: index) children)
]

{ #category : 'tests' }
DockMethodEditorTest >> selectClass [
	
	^ self selectPathByName: #(
		'Perspective' 
		'Dock-Browser-Tests' 
		'Uncategorized' 
		'DockTestClassToRemove')
]

{ #category : 'accessing' }
DockMethodEditorTest >> selectPathByName: aPath [
	| listPresenter |
	
	listPresenter := browser projectView listPresenter.
	
	listPresenter selectPath: (self 
		pathByName: aPath 
		in: listPresenter roots)
]

{ #category : 'running' }
DockMethodEditorTest >> tearDown [

	self ensureRemoveClass: #DockTestClassToRemove.		
	super tearDown
]

{ #category : 'tests' }
DockMethodEditorTest >> testSaveContentWithNewMethod [
	"test I can create a new class from the editor"
	| title editor class |
	
	class := self addClass.
	title := PvNewMethodTemplate new selector.

	self openBrowserOnProject.		 
	self selectClass.
	browser openClass: class.
	self waitForUI.

	browser outlineView instanceSidePresenter doRequestNewMethod.
	
	self waitForUI.
	
	editor := browser presenterWithTitle: title.
	self assert: editor notNil.
	
	editor presenter editorPresenter text: 'aMethodToTest
	^ 42'.
	editor presenter saveContent.
	
	self waitForUI.
	
	class := self class environment classNamed: #DockTestClassToRemove.
	self assert: (class includesSelector: #aMethodToTest) notNil.
	self assert: editor title equals: 'aMethodToTest'.
	self
		assert: editor presenter toolbarPresenter breadcrumbs segments first label
		equals: 'DockTestClassToRemove'.
	self
		assert: editor presenter toolbarPresenter breadcrumbs segments third label
		equals: 'aMethodToTest'.
	self 
		assert: (browser presenterWithClass: DockClassOutlineView) presenter model name 
		equals: 'DockTestClassToRemove'
]
