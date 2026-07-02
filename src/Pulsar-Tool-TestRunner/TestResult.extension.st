Extension { #name : 'TestResult' }

{ #category : '*Pulsar-Tool-TestRunner' }
TestResult >> dispatchResultsIntoHistory [

	self updateResultsInHistory
]

{ #category : '*Pulsar-Tool-TestRunner' }
TestResult >> hasEffectivePassed [
	"answer is has tests executed an passed. The other method (hasPassed) just veryfies 
	 that there are not failures and errors (tests passed could be = 0 and it will answer true)"

	^ self passedCount > 0
]
