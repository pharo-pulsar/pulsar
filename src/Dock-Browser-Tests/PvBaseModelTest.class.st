Class {
	#name : 'PvBaseModelTest',
	#superclass : 'TestCase',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'accessing' }
PvBaseModelTest >> environmentModel [

	^ PvEnvironmentModel onSystem
]
