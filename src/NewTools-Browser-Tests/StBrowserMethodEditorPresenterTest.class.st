Class {
	#name : #StBrowserMethodEditorPresenterTest,
	#superclass : #StBaseBrowserTest,
	#category : #'NewTools-Browser-Tests'
}

{ #category : #tests }
StBrowserMethodEditorPresenterTest >> assertActiveEditorHasCommand: aClass [ 
	| editor |

	editor := window presenter activeEditor.
	self assert: (editor toolbarActions allCommands 
		anySatisfy: [ :each | each decoratedCommand class = aClass ])
]

{ #category : #tests }
StBrowserMethodEditorPresenterTest >> testEditorHasCopyToClipboardToolbarOption [

	window := StEnvironmentBrowser openOnMethod: self class>>#testEditorHasCopyToClipboardToolbarOption.
	self waitUntilUIRedrawed.
	
	self assertActiveEditorHasCommand: StBrowseCopyToClipboardCommand
]

{ #category : #tests }
StBrowserMethodEditorPresenterTest >> testEditorHasVersionBrowserToolbarOption [

	window := StEnvironmentBrowser openOnMethod: self class>>#testEditorHasVersionBrowserToolbarOption.
	self waitUntilUIRedrawed.
	
	self assertActiveEditorHasCommand: StBrowseVersionsCommand
]
