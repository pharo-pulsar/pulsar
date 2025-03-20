Class {
	#name : 'DockProjectSnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'model'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing' }
DockProjectSnapshot >> model [

	^ model
]

{ #category : 'restoring' }
DockProjectSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter
]

{ #category : 'initialization' }
DockProjectSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	model := aPresenter model
]
