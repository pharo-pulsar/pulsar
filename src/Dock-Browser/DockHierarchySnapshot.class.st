Class {
	#name : 'DockHierarchySnapshot',
	#superclass : 'DockPanelSnapshot',
	#instVars : [
		'selectedPath'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'restoring' }
DockHierarchySnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter treePresenter selectPath: selectedPath
]

{ #category : 'initialization' }
DockHierarchySnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	selectedPath := aPresenter treePresenter selection selectedPath
]
