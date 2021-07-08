Class {
	#name : #StSystemEnvironment,
	#superclass : #StEnvironment,
	#category : #'NewTools-Browser'
}

{ #category : #accessing }
StSystemEnvironment >> projects [

	^ BaselineOf allSubclasses.
	
]
