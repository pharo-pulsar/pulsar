Class {
	#name : 'DockClassEditorTest',
	#superclass : 'DockEditorTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'accessing' }
DockClassEditorTest >> classToTest [

	^ DockClassEditor
]

{ #category : 'running' }
DockClassEditorTest >> ensureRemoveClass: aClassName [ 

	(self class environment classNamed: aClassName)
		ifNotNil: [ :aClass | aClass removeFromSystemUnlogged ].

]

{ #category : 'running' }
DockClassEditorTest >> tearDown [

	self ensureRemoveClass: #DockTestClassToRemove.		
	super tearDown
]

{ #category : 'tests' }
DockClassEditorTest >> testSaveContentWithNewClass [
	"test I can create a new class from the editor"
	| title editor |

	title := PvNewClassTemplate new name.

	self openBrowserOnProject.
	browser projectView listPresenter selectPath: #(1 1).
	browser projectView doRequestNewClass.
	editor := browser presenterWithTitle: title.
	
	editor presenter editorPresenter text: 'Object << #DockTestClassToRemove
	traits: {};
	slots: {};
	classSlots: {};
	sharedVariables: {};
	sharedPools: {};
	tag: '''';
	package: ''Dock-Browser-Tests'''.
	
	editor presenter saveContent.
	
	self assert: (self class environment classNamed: #DockTestClassToRemove) notNil.
	self assert: editor title equals: 'DockTestClassToRemove'.
	self 
		assert: (browser presenterWithClass: DockClassOutlineView) model name 
		equals: 'DockTestClassToRemove'
]
