Class {
	#name : #StBaseBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'window',
		'backend',
		'classFactory',
		'application'
	],
	#category : #'NewTools-Browser-Tests'
}

{ #category : #testing }
StBaseBrowserTest class >> isAbstract [

	^ super isAbstract or: [ self = StBaseBrowserTest ]
]

{ #category : #accessing }
StBaseBrowserTest >> browserClass [ 

	^ StEnvironmentBrowser
]

{ #category : #accessing }
StBaseBrowserTest >> classFactory [

	^ classFactory ifNil: [ classFactory := ClassFactoryForTestCase new ]
]

{ #category : #running }
StBaseBrowserTest >> runCase [

	^ StPharoApplication  
		use: application 
		during: [ super runCase ]
]

{ #category : #running }
StBaseBrowserTest >> setUp [

	super setUp.	
	backend := SpMorphicBackendForTest new.
	application := StPharoApplication new
]

{ #category : #running }
StBaseBrowserTest >> tearDown [

	window ifNotNil: [ window close. window := nil ].
	application reset.
	classFactory ifNotNil: [ classFactory cleanUp. classFactory := nil ].
	
	super tearDown
]

{ #category : #utilities }
StBaseBrowserTest >> waitUntilUIRedrawed [

	backend waitUntilUIRedrawed
]
