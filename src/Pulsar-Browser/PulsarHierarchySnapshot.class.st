Class {
	#name : 'PulsarHierarchySnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'selectedPath'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'restoring' }
PulsarHierarchySnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter treePresenter selectPath: selectedPath
]

{ #category : 'initialization' }
PulsarHierarchySnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	selectedPath := aPresenter treePresenter selection selectedPath
]
