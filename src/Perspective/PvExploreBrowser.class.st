Class {
	#name : #PvExploreBrowser,
	#superclass : #PvPerspectiveBrowser,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'projectPresenter'
	],
	#category : #'Perspective-View-Perspective'
}

{ #category : #initialization }
PvExploreBrowser >> initialize [

	super initialize.
	self useExplorerLayout.
	self addWindow: (projectPresenter := PvProjectView new).
	self addWindow: PvOutlineView new
]

{ #category : #actions }
PvExploreBrowser >> openProject: aBaselineClass [

	projectPresenter model: (PvProjectModel 
		newEntity: aBaselineClass
		environment: self model)
]

{ #category : #initialization }
PvExploreBrowser >> useExplorerLayout [

	self usePerspectiveLayout: PvExplorePerspectiveLayout
]
