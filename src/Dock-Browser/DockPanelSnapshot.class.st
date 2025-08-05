Class {
	#name : 'DockPanelSnapshot',
	#superclass : 'DockBaseSnapshot',
	#instVars : [
		'dockPosition',
		'presenterClass',
		'model'
	],
	#category : 'Dock-Browser-Snapshot',
	#package : 'Dock-Browser',
	#tag : 'Snapshot'
}

{ #category : 'accessing' }
DockPanelSnapshot >> dockPosition [

	^ dockPosition
]

{ #category : 'restoring' }
DockPanelSnapshot >> instantiateOn: parentPresenter [

	^ parentPresenter 
		instantiate: self presenterClass
		on: self model
]

{ #category : 'accessing' }
DockPanelSnapshot >> model [

	^ model
]

{ #category : 'accessing' }
DockPanelSnapshot >> presenterClass [

	^ presenterClass
]

{ #category : 'restoring' }
DockPanelSnapshot >> restoreTo: aPresenter [

	"The model is in fact set on class creation"
	"aPresenter model: self model"
]

{ #category : 'initialization' }
DockPanelSnapshot >> snapshot: aPresenter [

	presenterClass := aPresenter class.
	dockPosition := aPresenter panelWindow dockPosition.
	self takeModelSnapshot: aPresenter
]

{ #category : 'initialization' }
DockPanelSnapshot >> takeModelSnapshot: aPresenter [

	model := aPresenter model
]
