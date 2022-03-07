Class {
	#name : #StEnvironmentBrowserTest,
	#superclass : #StBaseBrowserTest,
	#category : #'NewTools-Browser-Tests'
}

{ #category : #tests }
StEnvironmentBrowserTest >> testActiveEditor [

	window := StEnvironmentBrowser openOnMethod: self class>>#testActiveEditor.
	self waitUntilUIRedrawed.

	self assert: window presenter activeEditor notNil.
	self assert: window presenter activeEditor isMethodEditor.
	
	window presenter selectClass: Object.
	self waitUntilUIRedrawed.
	self assert: window presenter activeEditor isClassEditor
]

{ #category : #tests }
StEnvironmentBrowserTest >> testChangeActiveEditorChangesBrowserTitle [
	| editorContainer |

	window := StEnvironmentBrowser openOnMethod: self class>>#testOpenOnMethod.
	self waitUntilUIRedrawed.

	editorContainer := window presenter editorContainer.
	self 
		assert: window title
		equals: editorContainer activeEditor model windowTitle.
	editorContainer selectEditor: (editorContainer editors detect: [ :each | each isClassEditor ]).
	self waitUntilUIRedrawed.
	self 
		assert: window title
		equals: editorContainer activeEditor model windowTitle
]

{ #category : #tests }
StEnvironmentBrowserTest >> testConsumePathWithClass [

	window := StEnvironmentBrowser open.

	window presenter consumePath: { 
		StPackageModel newPackage: Object package.
		StPackageTagModel newPackageTag: (Object package classTagForClass: Object).
		StClassModel newClass: Object.
	 }.	
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem name
		equals: 'Objects'.
		
	self 
		assert: window presenter packagesPanel classesPanel selectedItem modelClass
		equals: Object
]

{ #category : #tests }
StEnvironmentBrowserTest >> testConsumePathWithPackage [

	window := StEnvironmentBrowser open.

	window presenter consumePath: { 
		StPackageModel newPackage: Object package.
	 }.	
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem package
		equals: Object package
]

{ #category : #tests }
StEnvironmentBrowserTest >> testConsumePathWithPackageAndTag [

	window := StEnvironmentBrowser open.

	window presenter consumePath: { 
		StPackageModel newPackage: Object package.
		StPackageTagModel newPackageTag: (Object package classTagForClass: Object).
	 }.	
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem name
		equals: 'Objects'
]

{ #category : #tests }
StEnvironmentBrowserTest >> testOpenOnClass [

	window := StEnvironmentBrowser openOnClass: self class.
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem package
		equals: self class package.
		
	self 
		assert: window presenter packagesPanel classesPanel selectedItem modelClass
		equals: self class
]

{ #category : #tests }
StEnvironmentBrowserTest >> testOpenOnMethod [

	window := StEnvironmentBrowser openOnMethod: self class>>#testOpenOnMethod.
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem package
		equals: self class package.
		
	self 
		assert: window presenter packagesPanel classesPanel selectedItem modelClass
		equals: self class.
		
	self 
		assert: window presenter classPanel instanceSidePanel selectedItem method
		equals: self class	>> #testOpenOnMethod
]

{ #category : #tests }
StEnvironmentBrowserTest >> testOpenOnMethodClassSide [

	window := StEnvironmentBrowser openOnMethod: Object class	>> #initialize.
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem package
		equals: Object package.
		
	self 
		assert: window presenter packagesPanel classesPanel selectedItem modelClass
		equals: Object.
		
	self 
		assert: window presenter classPanel classSidePanel selectedItem method
		equals: Object class	>> #initialize
]

{ #category : #tests }
StEnvironmentBrowserTest >> testOpenOnMethodDoesNotMarkEditorDirty [

	window := StEnvironmentBrowser openOnMethod: self class>>#testOpenOnMethodDoesNotMarkEditorDirty.
	self waitUntilUIRedrawed.
	
	self deny: window presenter activeEditor isDirty
]

{ #category : #tests }
StEnvironmentBrowserTest >> testOpenOnPackage [

	window := StEnvironmentBrowser openOnPackage: self class package.
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem package
		equals: self class package
]

{ #category : #tests }
StEnvironmentBrowserTest >> testSelectMethodDoesNotMarkEditorDirty [
	| editorContainer |

	window := StEnvironmentBrowser openOnClass: self class.
	self waitUntilUIRedrawed.

	editorContainer := window presenter editorContainer.

	self 
		assert: editorContainer editors last class
		equals: StBrowserMethodTemplateEditorPresenter.

	window presenter classPanel consumePath: {
		StProtocolModel 
			newClass: self class
			protocol: (self class organization allProtocols first).
		StMethodModel newMethod: self class >> #testSelectMethodDoesNotMarkEditorDirty }.

	self waitUntilUIRedrawed.
	
	self deny: window presenter activeEditor isDirty
]

{ #category : #tests }
StEnvironmentBrowserTest >> testSelectMethodKeepsTemplateAtLast [
	| editorContainer |

	window := StEnvironmentBrowser openOnClass: self class.
	self waitUntilUIRedrawed.

	editorContainer := window presenter editorContainer.

	self 
		assert: editorContainer editors last class
		equals: StBrowserMethodTemplateEditorPresenter.

	window presenter classPanel consumePath: {
		StProtocolModel 
			newClass: self class
			protocol: (self class organization allProtocols first).
		StMethodModel newMethod: self class >> #testSelectMethodKeepsTemplateAtLast }.

	self waitUntilUIRedrawed.

	self assert: editorContainer editors size equals: 4.	
	self 
		assert: (editorContainer editors collect: #class as: Array)
		equals: { 
			StBrowserClassCommentPresenter. 
			StBrowserClassDefinitionPresenter. 
			StBrowserMethodEditorPresenter.
			StBrowserMethodTemplateEditorPresenter }
]
