Class {
	#name : 'PulsarPresenterWithModelSnapshot',
	#superclass : 'PulsarBaseSnapshot',
	#instVars : [
		'presenterClass',
		'model'
	],
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'restoring' }
PulsarPresenterWithModelSnapshot >> instantiateOn: aParent [

	^ aParent
		instantiate: self presenterClass 
		on: self model
]

{ #category : 'accessing' }
PulsarPresenterWithModelSnapshot >> model [

	^ model
]

{ #category : 'accessing' }
PulsarPresenterWithModelSnapshot >> presenterClass [

	^ presenterClass
]

{ #category : 'restoring' }
PulsarPresenterWithModelSnapshot >> restoreTo: aParent [

	^ self instantiateOn: aParent
]

{ #category : 'initialization' }
PulsarPresenterWithModelSnapshot >> snapshot: aPresenter [ 

	presenterClass := aPresenter class. 
	model := aPresenter model prepareForSnapshot
]
