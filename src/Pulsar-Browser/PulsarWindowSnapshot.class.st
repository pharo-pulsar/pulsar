Class {
	#name : 'PulsarWindowSnapshot',
	#superclass : 'PulsarBaseSnapshot',
	#instVars : [
		'snapshot'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'initialization' }
PulsarWindowSnapshot >> instantiateOn: parentPresenter [

	^ snapshot instantiateOn: parentPresenter
]

{ #category : 'restoring' }
PulsarWindowSnapshot >> restoreTo: aPresenter [

	^ snapshot restoreTo: aPresenter
]

{ #category : 'initialization' }
PulsarWindowSnapshot >> snapshot: aWindowPresenter [

	snapshot := aWindowPresenter presenter snapshot
]
