"
tags are not branches, clearly.
but they behave en many ways like one...
"
Class {
	#name : 'DockRepositoryTagBranchView',
	#superclass : 'DockRepositoryBaseBranchView',
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'private' }
DockRepositoryTagBranchView >> branches [

	^ self model tags
]
