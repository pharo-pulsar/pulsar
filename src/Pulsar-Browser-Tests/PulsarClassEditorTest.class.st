Class {
	#name : 'PulsarClassEditorTest',
	#superclass : 'PulsarEditorTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarClassEditorTest >> classToTest [

	^ PulsarClassEditor
]

{ #category : 'running' }
PulsarClassEditorTest >> tearDown [

	self ensureRemoveClass: #PulsarTestClassToRemove.		
	super tearDown
]

{ #category : 'tests' }
PulsarClassEditorTest >> testSaveContentWithNewClass [
	"test I can create a new class from the editor"
	| title editor |

	title := PvNewClassTemplate new name.

	self openBrowserOnProject.
	browser projectView listPresenter selectPath: #(1 1).
	browser projectView doRequestNewClass.
	self waitForUI.
	
	editor := browser presenterWithTitle: title.
	self assert: editor notNil.
	
	editor presenter editorPresenter text: 'Object << #PulsarTestClassToRemove
	traits: {};
	slots: {};
	classSlots: {};
	sharedVariables: {};
	sharedPools: {};
	tag: '''';
	package: ''Pulsar-Browser-Tests'''.
	
	editor presenter saveContent.
	
	self waitForUI.
	
	self assert: (self class environment classNamed: #PulsarTestClassToRemove) notNil.
	self assert: editor title equals: 'PulsarTestClassToRemove'.
	self
		assert: editor presenter toolbarPresenter breadcrumbs segments first label
		equals: 'PulsarTestClassToRemove'.
	
	self 
		assert: (browser presenterWithClass: PulsarClassOutlineView) presenter model name 
		equals: 'PulsarTestClassToRemove'
]
