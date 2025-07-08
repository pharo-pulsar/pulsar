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

{ #category : 'accessing' }
DockMethodEditorTest >> openMethodEditorOn: aMethod [
	| editor |

	editor := DockMethodEditor 
		newApplication: self application
		model: (PvMethodModel 
			newEnvironment: PvEnvironmentModel onSystem
			entity: aMethod).	
	editor notificationCenter: Announcer new.
	editor open.
	^ editor
]

{ #category : 'accessing' }
DockMethodEditorTest >> openMethodEditorWithBrowserOn: aMethod [
	
	browser := self openBrowserOnProject.
	browser openMethod: aMethod.
	
	"give some time to open"
	10 milliSeconds wait.
	
	^ browser editors first presenter
]

{ #category : 'running' }
DockMethodEditorTest >> tearDown [
	
	self application windows do: [ :each | each close ].
	self ensureRemoveClass: #DockTestClassToRemove.		
	self ensureRemoveMethod: #aMethod.
	super tearDown
]

{ #category : 'tests' }
DockMethodEditorTest >> testEditorUpdateWhenCodeUpdateElsewhere [
	| editor | 

	self class compile: 'aMethod ^ nil'.
	editor := self openMethodEditorWithBrowserOn: self class >> #aMethod.
	
	self 
		assert: editor editorPresenter text 
		equals: 'aMethod ^ nil'.
	
	self class compile: 'aMethod ^ 42'.
	"let the editors update. 500 milliSeconds is a lot, but then I am sure is enough :)"
	500 milliSeconds wait.
	
	self 
		assert: editor editorPresenter text 
		equals: 'aMethod ^ 42'
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
