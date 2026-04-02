"
I will perform a pull from a remote, to bring put repository in sync.

matches if: 
	- workingCopy is detached AND there is no commit in the current available commits
"
Class {
	#name : 'PulsarRepositoryRepairPullRemoteBranch',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairPullRemoteBranch class >> help [
	^ 'You can pull commits from a remote to put your image and your repository in sync.
This will not lose any change in the image.

This situation happens because the code loaded in your image is not in the branch currently selected on your repository.

This operation will modify the state of your working copy in disk. All non-committed changes in your disk working copy that are not in the image will be lost. If you want to keep them, perform a commit from outside before.'
]

{ #category : 'accessing' }
PulsarRepositoryRepairPullRemoteBranch class >> icon [
	^ self iconNamed: #down
]

{ #category : 'testing' }
PulsarRepositoryRepairPullRemoteBranch class >> isAvailableFor: aRepository [
	"matches if: 
		- workingCopy is detached AND there is no commit in the current available commits"

	aRepository isMissing ifTrue: [ ^ false ].
	aRepository workingCopy referenceCommit isUnknownCommit ifTrue: [ ^ false ].
	aRepository workingCopy referenceCommit isNoCommit ifTrue: [ ^ false ].

	^ aRepository workingCopy isDetached and: [ (aRepository includesCommit: aRepository workingCopy referenceCommit) not ]
]

{ #category : 'accessing' }
PulsarRepositoryRepairPullRemoteBranch class >> order [
	^ 17
]

{ #category : 'accessing' }
PulsarRepositoryRepairPullRemoteBranch class >> title [
	^ 'Pull remote commits to put your repository in sync'
]

{ #category : 'executing' }
PulsarRepositoryRepairPullRemoteBranch >> basicExecute [

	"Fetching remotes is necessary in case the current image commit is not in 
	the repository. Could be optimized"
	self fetchAllRemotes.
	(PulsarRepositoryActionContext on: context) doPull: self repositoryModel
]
