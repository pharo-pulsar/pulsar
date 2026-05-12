Class {
	#name : 'PulsarRepositoriesSnapshot',
	#superclass : 'PulsarPanelSnapshot',
	#instVars : [
		'hideSystemProjects',
		'hideNonDirtyProjects'
	],
	#category : 'Pulsar-Tool-Repositories-View-Repositories',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Repositories'
}

{ #category : 'testing' }
PulsarRepositoriesSnapshot >> isHideNonDirtyProjects [

	^ hideNonDirtyProjects
]

{ #category : 'testing' }
PulsarRepositoriesSnapshot >> isHideSystemProjects [

	^ hideSystemProjects
]

{ #category : 'restoring' }
PulsarRepositoriesSnapshot >> restoreTo: aPresenter [

	super restoreTo: aPresenter.
	aPresenter postRestoreSnapshot: self
]

{ #category : 'initialization' }
PulsarRepositoriesSnapshot >> snapshot: aPresenter [

	super snapshot: aPresenter.
	hideSystemProjects := aPresenter isHideSystemProjects.
	hideNonDirtyProjects := aPresenter isHideNonDirtyProjects
]
