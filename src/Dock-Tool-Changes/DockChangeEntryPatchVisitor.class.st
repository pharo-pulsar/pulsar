Class {
	#name : 'DockChangeEntryPatchVisitor',
	#superclass : 'EpEntryContentVisitor',
	#instVars : [
		'patchPresenter'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'instance creation' }
DockChangeEntryPatchVisitor class >> on: aPatchPresenter [

	^ self new 
		patchPresenter: aPatchPresenter;
		yourself
]

{ #category : 'accessing' }
DockChangeEntryPatchVisitor >> patchPresenter: aPatchPresenter [

	patchPresenter := aPatchPresenter
]

{ #category : 'visitor' }
DockChangeEntryPatchVisitor >> visitBehaviorCommentChange: aChange [

	patchPresenter 
		patchFrom: aChange oldComment
		to: aChange newComment
]

{ #category : 'visitor' }
DockChangeEntryPatchVisitor >> visitEvent: aChange [

	patchPresenter patchFrom: '' to: ''
]

{ #category : 'visitor' }
DockChangeEntryPatchVisitor >> visitMethodAddition: aChange [

	patchPresenter 
		patchFrom: ''
		to: aChange sourceCode
]

{ #category : 'visitor' }
DockChangeEntryPatchVisitor >> visitMethodModification: aChange [

	patchPresenter 
		patchFrom: aChange oldSourceCode 
		to: aChange newSourceCode
]

{ #category : 'visitor' }
DockChangeEntryPatchVisitor >> visitMethodRemoval: aChange [

	patchPresenter 
		patchFrom: aChange sourceCode
		to: ''
]

{ #category : 'visitor' }
DockChangeEntryPatchVisitor >> visitProtocolAddition: aChange [

	self visitEvent: aChange
]
