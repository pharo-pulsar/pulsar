Class {
	#name : 'DockRepositoriesSnapshot',
	#superclass : 'DockPanelSnapshot',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'initialization' }
DockRepositoriesSnapshot >> takeModelSnapshot: aPresenter [
	
	model := aPresenter model prepareForSnapshot
]
