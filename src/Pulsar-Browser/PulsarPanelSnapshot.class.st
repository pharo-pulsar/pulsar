Class {
	#name : 'PulsarPanelSnapshot',
	#superclass : 'PulsarBaseSnapshot',
	#instVars : [
		'dockPosition',
		'presenterClass',
		'model'
	],
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'accessing' }
PulsarPanelSnapshot >> dockPosition [

	^ dockPosition
]

{ #category : 'restoring' }
PulsarPanelSnapshot >> instantiateOn: parentPresenter [

	^ parentPresenter 
		instantiate: self presenterClass
		on: self model
]

{ #category : 'accessing' }
PulsarPanelSnapshot >> model [

	^ model
]

{ #category : 'accessing' }
PulsarPanelSnapshot >> presenterClass [

	^ presenterClass
]

{ #category : 'restoring' }
PulsarPanelSnapshot >> restoreTo: aPresenter [

	"The model is in fact set on class creation"
	"aPresenter model: self model"
]

{ #category : 'initialization' }
PulsarPanelSnapshot >> snapshot: aPresenter [

	presenterClass := aPresenter class.
	dockPosition := aPresenter panelWindow dockPosition.
	self takeModelSnapshot: aPresenter
]

{ #category : 'initialization' }
PulsarPanelSnapshot >> takeModelSnapshot: aPresenter [

	model := aPresenter model
]
