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
StEnvironmentBrowserTest >> testOpenOnClass [

	window := StEnvironmentBrowser openOnClass: self class.
	

]

{ #category : #tests }
StEnvironmentBrowserTest >> testOpenOnPackage [

	window := StEnvironmentBrowser openOnPackage: self class package.
	

]
