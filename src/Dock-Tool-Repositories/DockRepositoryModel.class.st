Class {
	#name : 'DockRepositoryModel',
	#superclass : 'PvBaseModel',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'accessing' }
DockRepositoryModel >> diffToReferenceCommit [
	| diff |
	
	diff := self entity workingCopy diffToReferenceCommit.
	
	
	^ DockDiffNode on: diff tree
]

{ #category : 'accessing' }
DockRepositoryModel >> location [

	^ self entity location
]

{ #category : 'accessing' }
DockRepositoryModel >> name [

	^ self entity name
]

{ #category : 'accessing' }
DockRepositoryModel >> status [
	
	[
		self entity isMissing 				ifTrue: [ ^ #missing ].
		self entity loadedPackages isEmpty 	ifTrue: [ ^ #notLoaded ].
		self entity 	workingCopy isModified 	ifTrue: [ ^ #modified ].
		^ #upToDate ]
	on: Error 
	do: [ :e | 
		logger error: e.
		^ #error ]
]
