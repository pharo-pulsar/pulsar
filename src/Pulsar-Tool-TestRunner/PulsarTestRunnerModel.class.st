"
Model for the PulsarTestRunnerBrowser, wrapping a PulsarBaseProjectModel as its entity.

Builds the test tree from the project's packages, manages test selection and execution, and stores the last test run result.
"
Class {
	#name : 'PulsarTestRunnerModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'suites',
		'mutex',
		'pendingSelection'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'tree building' }
PulsarTestRunnerModel >> buildSuites [
	"Scan the project for TestCase subclasses and build PulsarTestSuite instances."

	| allPackages testClasses |
	allPackages := self projectModel packagesOn: self projectModel entity.
	testClasses := IdentitySet new.
	allPackages do: [ :eachPkg |
			eachPkg definedClasses do: [ :eachClass |
					((eachClass inheritsFrom: TestCase) and: [ eachClass isAbstract not and: [ eachClass allTestSelectors isNotEmpty ] ])
						ifTrue: [ testClasses add: eachClass ] ] ].
	^ (testClasses sorted: #name ascending) collect: [ :eachClass |
		  PulsarTestSuite newEnvironment: self environmentModel entity: eachClass ]
]

{ #category : 'selection' }
PulsarTestRunnerModel >> consumePendingSelection [

	| value |
	value := pendingSelection.
	pendingSelection := nil.
	^ value
]

{ #category : 'running' }
PulsarTestRunnerModel >> debugCase: aCase announcingTo: aNotificationCenter [
	| suite |
	
	suite := TestSuite named: self name.
	suite addTest: aCase entity.
	^ self 
		debugSuite: suite 
		for: { aCase }
		announcingTo: aNotificationCenter
]

{ #category : 'running' }
PulsarTestRunnerModel >> debugSuite: aTestSuite for: caseCollection announcingTo: aNotificationCenter [

    ^ self
        executeSuite: aTestSuite
        announcingTo: aNotificationCenter
        inMode: ExecutionMode debugMode
]

{ #category : 'running' }
PulsarTestRunnerModel >> executeSuite: aTestSuite announcingTo: aNotificationCenter inMode: anExecutionMode [

    ^ NewTestRunner
        executeSuite: aTestSuite
        announcingTo: aNotificationCenter
        inMode: anExecutionMode
]

{ #category : 'filtering' }
PulsarTestRunnerModel >> filterWith: aString [
	| allCases |
	
	allCases := self suites flatCollect: [ :eachSuite | eachSuite children ].
	^ allCases select: [ :eachCase | 
		eachCase description includesSubstring: aString caseSensitive: false ]
]

{ #category : 'initialization' }
PulsarTestRunnerModel >> initialize [

	super initialize.
	mutex := Mutex new
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> mutex [

	^ mutex
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> mutex: anObject [

	mutex := anObject
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> name [

	^ 'Tests: {1}' format: { self projectModel name }
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> projectModel [

	^ self entity
]

{ #category : 'tree building' }
PulsarTestRunnerModel >> refresh [

	suites := nil.
	self suites
]

{ #category : 'running' }
PulsarTestRunnerModel >> runAllTestsAnnouncingTo: aNotificationCenter [
	| allCases |
	
	allCases := self suites flatCollect: #children.
	self 
		runSuite: (self suiteFromCases: allCases) 
		for: allCases 
		announcingTo: aNotificationCenter
]

{ #category : 'running' }
PulsarTestRunnerModel >> runCase: aCase announcingTo: aNotificationCenter [
	| suite |
	
	suite := TestSuite named: self name.
	suite addTest: aCase entity.
	^ self 
		runSuite: suite 
		for: { aCase } 
		announcingTo: aNotificationCenter
]

{ #category : 'running' }
PulsarTestRunnerModel >> runSuite: aPulsarSuite announcingTo: aNotificationCenter [
	| cases suite |
	
	cases := aPulsarSuite children.
	cases ifEmpty: [ ^ self ].
	suite := self suiteFromCases: cases.
	^ self 
		runSuite: suite 
		for: cases 
		announcingTo: aNotificationCenter
]

{ #category : 'running' }
PulsarTestRunnerModel >> runSuite: aTestSuite for: caseCollection announcingTo: aNotificationCenter [

    ^ self
        executeSuite: aTestSuite
        announcingTo: aNotificationCenter
        inMode: ExecutionMode runTestsMode
]

{ #category : 'selection' }
PulsarTestRunnerModel >> selectCaseFromModel: aMethodModel [
	"Set pendingSelection to the PulsarTestCase matching aMethodModel's entity."

	| targetClass targetSelector |
	targetClass := aMethodModel methodClass.
	targetSelector := aMethodModel entity selector.
	pendingSelection := (self suites detect: [ :each | each entity = targetClass ] ifNone: [ nil ]) ifNotNil: [ :suite |
		                    suite children detect: [ :each | each entity selector = targetSelector ] ifNone: [ nil ] ]
]

{ #category : 'selection' }
PulsarTestRunnerModel >> selectSuiteFromModel: aClassModel [
	"Set pendingSelection to the PulsarTestSuite matching aClassModel's entity."

	pendingSelection := self suites detect: [ :each | each entity = aClassModel entity ] ifNone: [ nil ]
]

{ #category : 'running' }
PulsarTestRunnerModel >> suiteFromCases: aCaseCollection [
	| suite |
	
	suite := TestSuite named: self name.
	aCaseCollection do: [ :eachCase | suite addTest: eachCase entity ].
	
	^ suite
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> suites [

	^ suites ifNil: [ suites := self buildSuites ]
]

{ #category : 'accessing' }
PulsarTestRunnerModel >> suites: anObject [

	suites := anObject
]
