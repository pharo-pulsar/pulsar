Extension { #name : 'TestResult' }

{ #category : '*Pulsar-Tool-TestRunner' }
TestResult >> hasEffectivePassed [

	^ self passedCount > 0
]
