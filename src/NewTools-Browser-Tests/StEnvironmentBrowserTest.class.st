Class {
	#name : #StEnvironmentBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'window',
		'backup'
	],
	#category : #'NewTools-Browser-Tests'
}

{ #category : #running }
StEnvironmentBrowserTest >> setUp [

	super setUp.	
	backup := SpMorphicBackendForTest new
]

{ #category : #running }
StEnvironmentBrowserTest >> tearDown [

	window ifNotNil: [ 
		window close.
		window := nil ].
	super tearDown
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
StEnvironmentBrowserTest >> testOpenOnPackage [

	window := StEnvironmentBrowser openOnPackage: self class package.
	self waitUntilUIRedrawed.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem package
		equals: self class package
]

{ #category : #utilities }
StEnvironmentBrowserTest >> waitUntilUIRedrawed [

	backup waitUntilUIRedrawed
]
