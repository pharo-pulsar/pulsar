Class {
	#name : #StEnvironmentBrowserFeatureTest,
	#superclass : #StBaseFeatureTest,
	#category : #'NewTools-Browser-Tests'
}

{ #category : #'tests - opening' }
StEnvironmentBrowserFeatureTest >> testBrowserCanBeOpenedInAClass [

	window := self browserClass openOnClass: self class.
	self waitUntilUIRedrawed.
	
	self assert: window presenter selection notNil.
	self 
		assert: window presenter selection modelClass 
		equals: self class
]

{ #category : #'tests - opening' }
StEnvironmentBrowserFeatureTest >> testBrowserCanBeOpenedInAMethod [

	window := self browserClass openOnMethod: self class>>#testBrowserCanBeOpenedInAMethod.
	self waitUntilUIRedrawed.
	
	self assert: window presenter selection notNil.
	self 
		assert: window presenter selection method 
		equals: self class>>#testBrowserCanBeOpenedInAMethod.
]

{ #category : #'tests - opening' }
StEnvironmentBrowserFeatureTest >> testBrowserCanBeOpenedInAPackage [

	window := self browserClass openOnPackage: self class package.
	self waitUntilUIRedrawed.
	
	self assert: window presenter selection notNil.
	self 
		assert: window presenter selection package 
		equals: self class package
]

{ #category : #'tests - editing' }
StEnvironmentBrowserFeatureTest >> testMethodEditionHasCopyMethodAction [
	| method |

	method := self class>>#testMethodEditionHasCopyMethodAction.
	window := self browserClass new 
		application: application;
		selectMethod: method;
		openWithSpec.
	self waitUntilUIRedrawed.
	
	window presenter activeEditor doCopyToClipboard.
	
	self assert: Clipboard clipboardText equals: method sourceCode

]

{ #category : #'tests - editing' }
StEnvironmentBrowserFeatureTest >> testMethodEditionHasVersionBrowserAction [

	window := self browserClass new 
		application: application;
		selectMethod: self class>>#testMethodEditionHasVersionBrowserAction;
		openWithSpec.
	self waitUntilUIRedrawed.
	
	self assert: application windows size equals: 1.
	window presenter activeEditor doBrowseVersions.
	self assert: application windows size equals: 2.
	self assert: (application windows includes: window).
]

{ #category : #'tests - editing' }
StEnvironmentBrowserFeatureTest >> testSaveMethodEditorWillUpdateCorrespondingMethod [
	| class |

	class := self classFactory newClass. 
	class compile: 'test1 ^ nil' classified: 'accessing'.
	window := self browserClass openOnMethod: class>>#test1.
	self waitUntilUIRedrawed.
	
	self assert: class new test1 equals: nil.
	
	window presenter activeEditor
		content: 'test1 ^ 42';
		submit.

	self assert: class new test1 equals: 42
]

{ #category : #'tests - selection' }
StEnvironmentBrowserFeatureTest >> testSelectClassShowsClassCommentEditor [
	"When selecting a class, browser shows a panel with comment editor"

	window := self browserClass openOnClass: self class.
	self waitUntilUIRedrawed.
	
	self assert: (window presenter editorContainer 
		hasEditorSuchAs: [ :each | 
			each isClassEditor and: [ each isCommentEditor ] ])
]

{ #category : #'tests - selection' }
StEnvironmentBrowserFeatureTest >> testSelectClassShowsClassDefinitionEditor [
	"when selecting a class, browser shows a panel with the class definition template"

	window := self browserClass openOnClass: self class.
	self waitUntilUIRedrawed.
	
	self assert: (window presenter editorContainer 
		hasEditorSuchAs: [ :each | 
			each isClassEditor and: [ each isClassDefinitionEditor ] ])
]

{ #category : #'tests - selection' }
StEnvironmentBrowserFeatureTest >> testSelectClassShowsMethodTemplateEditor [

	window := self browserClass openOnClass: self class.
	self waitUntilUIRedrawed.
	
	self assert: (window presenter editorContainer 
		hasEditorSuchAs: [ :each | 
			each isMethodEditor
				and: [ each model isTemplate ] ])
]
