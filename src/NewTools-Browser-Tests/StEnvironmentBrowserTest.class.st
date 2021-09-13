Class {
	#name : #StEnvironmentBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'window'
	],
	#category : #'NewTools-Browser-Tests'
}

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
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem name
		equals: 'Objects'
]

{ #category : #tests }
StEnvironmentBrowserTest >> testOpenOnClass [

	window := StEnvironmentBrowser openOnClass: self class.
	
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
StEnvironmentBrowserTest >> testOpenOnPackage [

	window := StEnvironmentBrowser openOnPackage: self class package.
	
	self 
		assert: window presenter packagesPanel packagesTree selectedItem package
		equals: self class package
]
