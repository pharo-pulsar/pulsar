Class {
	#name : 'DockPanelSnapshot',
	#superclass : 'DockBaseSnapshot',
	#instVars : [
		'dockPosition',
		'presenterClass'
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

	^ nil
]

{ #category : 'accessing' }
DockPanelSnapshot >> presenterClass [

	^ presenterClass
]

{ #category : 'restoring' }
DockPanelSnapshot >> restoreTo: aPresenter [

]

{ #category : 'initialization' }
DockPanelSnapshot >> snapshot: aPresenter [
	
	presenterClass := aPresenter class.
	dockPosition := aPresenter panelWindow dockPosition
]
