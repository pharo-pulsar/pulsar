Class {
	#name : 'PulsarProjectSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'expandedItems'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing' }
PulsarProjectSnapshot >> expandedItems [

	^ expandedItems
]

{ #category : 'accessing' }
PulsarProjectSnapshot >> model [

	^ model
]

{ #category : 'restoring' }
PulsarProjectSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	expandedItems ifNil: [ ^ self ].
	aPresenter expandedItems: expandedItems.
	aPresenter restoreExpandedBranches
]

{ #category : 'initialization' }
PulsarProjectSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	model := aPresenter model.
	expandedItems := aPresenter expandedItems asArray
]
