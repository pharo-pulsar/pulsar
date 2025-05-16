Class {
	#name : 'DockOpenGitRepositoriesCommand',
	#superclass : 'DockToolCommand',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockOpenGitRepositoriesCommand >> defineAction [

	self name: 'Open Repositories'.
	self description: 'Open git repositories.'.
	self priority: 900
]

{ #category : 'executing' }
DockOpenGitRepositoriesCommand >> execute [

	self context spawnGitRepositories
]
