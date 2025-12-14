Class {
	#name : 'DockRepositoryTagModel',
	#superclass : 'DockRepositoryBranchModel',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'testing' }
DockRepositoryTagModel >> isHead [
	"tags are not head"
	
	^ false
]
