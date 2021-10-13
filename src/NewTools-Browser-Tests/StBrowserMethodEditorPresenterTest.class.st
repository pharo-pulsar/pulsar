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

{ #category : #tests }
StBrowserMethodEditorPresenterTest >> testTypeTextMarksTheEditorAsDirty [
	| editor |

	editor := StBrowserMethodEditorPresenter on: (StMethodModel newMethod: self class>>#testTypeTextMarksTheEditorAsDirty).
		
	self deny: editor isDirty.
	editor typeByChar: 'x'.
	self assert: editor isDirty
]
