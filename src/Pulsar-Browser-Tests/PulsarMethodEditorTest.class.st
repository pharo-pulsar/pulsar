Class {
	#name : 'PulsarMethodEditorTest',
	#superclass : 'PulsarEditorTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarMethodEditorTest >> classToTest [

	^ PulsarClassEditor
]

{ #category : 'accessing' }
PulsarMethodEditorTest >> openMethodEditorOn: aMethod [
	| editor |

	editor := PulsarMethodEditor 
		newApplication: self application
		model: (PvMethodModel 
			newEnvironment: PvEnvironmentModel onSystem
			entity: aMethod).	
	editor notificationCenter: Announcer new.
	editor open.
	^ editor
]

{ #category : 'accessing' }
PulsarMethodEditorTest >> openMethodEditorWithBrowserOn: aMethod [
	
	browser := self openBrowserOnProject.
	browser openMethod: aMethod.
	
	"give some time to open"
	10 milliSeconds wait.
	
	^ browser editors first presenter
]

{ #category : 'running' }
PulsarMethodEditorTest >> tearDown [
	
	self application windows do: [ :each | each close ].
	self ensureRemoveClass: #PulsarTestClassToRemove.		
	self ensureRemoveMethod: #aMethod.
	super tearDown
]

{ #category : 'tests' }
PulsarMethodEditorTest >> testEditorUpdateWhenCodeUpdateElsewhere [
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
PulsarMethodEditorTest >> testSaveContentWithNewMethod [
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
	
	class := self class environment classNamed: #PulsarTestClassToRemove.
	self assert: (class includesSelector: #aMethodToTest) notNil.
	self assert: editor title equals: 'aMethodToTest'.
	self
		assert: editor presenter toolbarPresenter breadcrumbs segments first label
		equals: 'PulsarTestClassToRemove'.
	self
		assert: editor presenter toolbarPresenter breadcrumbs segments third label
		equals: 'aMethodToTest'.
	self 
		assert: (browser presenterWithClass: PulsarClassOutlineView) presenter model name 
		equals: 'PulsarTestClassToRemove'
]
