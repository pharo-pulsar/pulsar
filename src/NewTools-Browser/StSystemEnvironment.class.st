Class {
	#name : #StSystemEnvironment,
	#superclass : #StEnvironment,
	#category : #'NewTools-Browser'
}

{ #category : #accessing }
StSystemEnvironment >> baselines [

	^ BaselineOf allSubclasses
]

{ #category : #accessing }
StSystemEnvironment >> packages [
	
	^ RPackageOrganizer default packages
]
