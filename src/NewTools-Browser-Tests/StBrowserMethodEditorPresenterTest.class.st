Class {
	#name : #StBrowserMethodEditorPresenterTest,
	#superclass : #StBaseBrowserTest,
	#category : #'NewTools-Browser-Tests'
}

{ #category : #private }
StBrowserMethodEditorPresenterTest >> assertActiveEditorHasCommand: aClass [ 
	| editor |

	editor := window presenter activeEditor.
	self assert: (editor toolbarActions allCommands 
		anySatisfy: [ :each | each decoratedCommand class = aClass ])
]

{ #category : #tests }
StBrowserMethodEditorPresenterTest >> testDirtyEditorWindowTitleIsMarkedWithAsterisk [
	| editor |

	editor := StBrowserMethodEditorPresenter on: (StMethodModel newMethod: self class>>#testTypeTextMarksTheEditorAsDirty).
		
	editor markDirty.
	self assert: (editor windowTitle beginsWith: '*')
	
]

{ #category : #'tests - commands' }
StBrowserMethodEditorPresenterTest >> testEditorHasCopyToClipboardToolbarOption [

	window := StEnvironmentBrowser openOnMethod: self class>>#testEditorHasCopyToClipboardToolbarOption.
	self waitUntilUIRedrawed.
	
	self assertActiveEditorHasCommand: StBrowseCopyToClipboardCommand
]

{ #category : #'tests - commands' }
StBrowserMethodEditorPresenterTest >> testEditorHasVersionBrowserToolbarOption [

	window := StEnvironmentBrowser openOnMethod: self class>>#testEditorHasVersionBrowserToolbarOption.
	self waitUntilUIRedrawed.
	
	self assertActiveEditorHasCommand: StBrowseVersionsCommand
]

{ #category : #'tests - commands' }
StBrowserMethodEditorPresenterTest >> testReplaceWithCleansDirtyState [
	| editor replace |

	editor := StBrowserMethodEditorPresenter on: (StMethodModel newMethod: self class>>#testTypeTextMarksTheEditorAsDirty).
	replace := StBrowserMethodEditorPresenter on: (StMethodModel newMethod: self class>>#testTypeTextMarksTheEditorAsDirty).
	editor content: 'abc'.
	
	editor typeByChar: 'x'.
	self assert: editor isDirty.
	
	editor replaceWith: replace.
	
	self deny: editor isDirty
]

{ #category : #tests }
StBrowserMethodEditorPresenterTest >> testTypeTextMarksTheEditorAsDirty [
	| editor |

	editor := StBrowserMethodEditorPresenter on: (StMethodModel newMethod: self class>>#testTypeTextMarksTheEditorAsDirty).
	editor content: 'abc'.
	
	self deny: editor isDirty.
	editor typeByChar: 'x'.
	self assert: editor isDirty
]
