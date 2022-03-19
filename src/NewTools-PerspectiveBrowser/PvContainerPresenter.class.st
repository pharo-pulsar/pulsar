Class {
	#name : #PvContainerPresenter,
	#superclass : #LnContainerPresenter,
	#instVars : [
		'name'
	],
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #initialization }
PvContainerPresenter >> defaultTileLayout [

	^ LnTileTabLayout uniqueInstance
]

{ #category : #accessing }
PvContainerPresenter >> name [

	^ name
]

{ #category : #accessing }
PvContainerPresenter >> name: anObject [

	name := anObject
]
