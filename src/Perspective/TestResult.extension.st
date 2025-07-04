Extension { #name : 'TestResult' }

{ #category : '*Perspective' }
TestResult class >> fromTestCaseHistory: aTestClass [
	| result history |

	result := self new.
	history := aTestClass history.
	
	result timeStamp: (history at: #timeStamp).
	history at: #passed ifPresent: [ :aSet | 
		aSet do: [ :each | result addPass: (aTestClass selector: each) ] ].
	history at: #failures ifPresent: [ :aSet | 
		aSet do: [ :each | result addFailure: (aTestClass selector: each) ] ].
	history at: #errors ifPresent: [ :aSet | 
		aSet do: [ :each | result addError: (aTestClass selector: each) ] ].
	
	^ result
]
