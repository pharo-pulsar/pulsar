Class {
	#name : 'DockMethodEditorTest',
	#superclass : 'DockEditorTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'accessing' }
DockMethodEditorTest >> classToTest [

	^ DockClassEditor
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
