"
I will perform a switch and merge of current reference commit with the selected branch. 

I'm active when: 
	- working copy is detached 
	- repository HEAD is NOT detached
"
Class {
	#name : 'PulsarRepositoryRepairMergeWithBranch',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairMergeWithBranch class >> help [
	^ 'This action checkouts an existing branch and loads the code in your image without discarding any change.
This will not lose any change in the image but may lead to conflicts. If there are conflicts it opens a merge view.

This situation happens because loaded code in your image is from a different commit than the current commit (HEAD) in the repository.

This operation will modify the state of your working copy in disk, the checkouted branch will replace the disk working copy. All non-committed changes in your disk working copy will be lost. If you want to keep them, perform a commit from outside before.'
]

{ #category : 'accessing' }
PulsarRepositoryRepairMergeWithBranch class >> icon [
	^ self iconNamed: #merge
]

{ #category : 'testing' }
PulsarRepositoryRepairMergeWithBranch class >> isAvailableFor: aRepository [
	"matches if: 
		- workingCopy is detached
		- HEAD is NOT detached"
		
	aRepository isMissing ifTrue: [ ^ false ].
	aRepository workingCopy referenceCommit isUnknownCommit ifTrue: [ ^ false ].
	aRepository workingCopy referenceCommit isNoCommit ifTrue: [ ^ false ].
		
	^ aRepository workingCopy isDetached and: [ aRepository head isDetached not ]
]

{ #category : 'accessing' }
PulsarRepositoryRepairMergeWithBranch class >> order [
	^ 20
]

{ #category : 'accessing' }
PulsarRepositoryRepairMergeWithBranch class >> title [
	^ 'Checkout an existing branch and merge the changes into the image (without discarding image changes)'
]

{ #category : 'executing' }
PulsarRepositoryRepairMergeWithBranch >> basicExecute [

	self fetchAllRemotes.
	((IceTipMergeBranchDialogPresenter 
		newApplication: context application 
		model: self repositoryModel) 
		beSwitchAndMerge;
		asDialogWindow)
			centeredRelativeTo: context window;
			open
]
