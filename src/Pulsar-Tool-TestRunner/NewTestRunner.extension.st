Extension { #name : 'NewTestRunner' }

{ #category : '*Pulsar-Tool-TestRunner' }
NewTestRunner class >> executeSuite: aTestSuite announcingTo: anAnnouncer inMode: anExecutionMode [
	"Run all tests of aTestSuite through a NewTestRunner, forwarding
     TestCaseAnnouncement events to anAnnouncer for live streaming.

     The single ensure block runs three cleanup steps that must always
     execute — whether the suite completes normally or a process is
     terminated by the user abandoning the debugger:
       1. Announce TestSuiteEnded (for browser inform + view updates)
       2. Dispatch results into SUnit class history (merge, not replace)
       3. Tear down suite resources"
	| runner |
	
	runner := self new.
	runner suite: aTestSuite.
	runner executionMode: anExecutionMode.
	runner prepareSuite.

	aTestSuite announceTo: anAnnouncer during: [
		aTestSuite setUp.
		[
			aTestSuite tests do: [ :eachTest |
				self
					executeTestCase: eachTest
					withRunner: runner
					suite: aTestSuite
					inMode: anExecutionMode ] ] 
		ensure: [
			aTestSuite testSuiteAnnouncer announce: (TestSuiteEnded result: runner result).
			runner result dispatchResultsIntoHistory.
			aTestSuite tearDown ] 
	].

	runner tearDown.

	^ runner result
]

{ #category : '*Pulsar-Tool-TestRunner' }
NewTestRunner class >> executeTestCase: aTestCase withRunner: aRunner suite: aTestSuite inMode: anExecutionMode [
	"Execute aTestCase using anExecutionMode and merge the result into aRunner.

     The ensure block guarantees cleanup and result recording even when the
     user abandons the debugger. When executeCase: is abandoned testResult
     stays nil: we recover the correct failure/error classification from the
     SUnit history, which the debug method already wrote before opening the
     debugger."

	| testResult |
	aTestCase prepareToRunOn: aTestSuite.
	testResult := nil.
	[
		testResult := anExecutionMode executeCase: aTestCase.
		aRunner result mergeWith: testResult ] 
	ensure: [
		testResult ifNil: [ 
			self recoverTestCase: aTestCase into: aRunner ].
		aTestCase cleanAfterRunOn: aTestSuite ]
]

{ #category : '*Pulsar-Tool-TestRunner' }
NewTestRunner class >> recoverTestCase: aTestCase into: aRunner [
	"Read the test's status from SUnit class-side history, which was
     updated by debug before opening the debugger, and record it in aRunner."
	| history selector |
	
	history := aTestCase class history.
	selector := aTestCase selector.

	((history at: #errors ifAbsent: [ #() ]) includes: selector) 
		ifTrue: [ ^ aRunner result addError: aTestCase ].
	((history at: #failures ifAbsent: [ #() ]) includes: selector) 
		ifTrue: [ ^ aRunner result addFailure: aTestCase ].
	((history at: #passed ifAbsent: [ #() ]) includes: selector) 
		ifTrue: [ ^ aRunner result addPass: aTestCase ].
	
	aRunner result addError: aTestCase
]
