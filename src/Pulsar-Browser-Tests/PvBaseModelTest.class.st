Class {
	#name : 'PvBaseModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PvBaseModelTest >> environmentModel [

	^ PvEnvironmentModel onSystem
]
