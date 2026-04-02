"
I will fetch repositories to try to find the unknown commit. 

matches if: 
	- workingCopy referenceCommit isUnknownCommit

"
Class {
	#name : 'PulsarRepositoryRepairFetchRemoteBranch',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairFetchRemoteBranch class >> help [
	^ 'You can fetch commits from a remote to find your image commit in your repository.
This will not lose any change in the image or the repository.
It will only fetch all the commits from the remotes, without changing the current commit (HEAD) nor branch.

This situation happens because the code loaded in your image is not in the branch currently selected on your repository.

After doing the fetch, it is required to create a new branch to commit into the repository. 
A second repair action will help you.'
]

{ #category : 'accessing' }
PulsarRepositoryRepairFetchRemoteBranch class >> icon [
	^ self iconNamed: #smallUpdate
]

{ #category : 'testing' }
PulsarRepositoryRepairFetchRemoteBranch class >> isAvailableFor: aRepository [
	"matches if: 
		- workingCopy referenceCommit isUnknownCommit"
		
	^ aRepository isMissing not 
		and: [ aRepository workingCopy referenceCommit isUnknownCommit ]
]

{ #category : 'accessing' }
PulsarRepositoryRepairFetchRemoteBranch class >> order [
	^ 15
]

{ #category : 'accessing' }
PulsarRepositoryRepairFetchRemoteBranch class >> title [
	^ 'Fetch remote commits including the commits of the image version'
]

{ #category : 'executing' }
PulsarRepositoryRepairFetchRemoteBranch >> basicExecute [
	"Fetching remotes is necessary in case the current image commit is not 
	 in the repository. Could be optimized"
	self fetchAllRemotes
]

{ #category : 'executing' }
PulsarRepositoryRepairFetchRemoteBranch >> finishSuccess [
	super finishSuccess.
	self notifyRepositoryModified
]
