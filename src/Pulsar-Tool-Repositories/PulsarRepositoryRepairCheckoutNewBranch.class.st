"
I will perform a checkout of a new branch starting from the current reference commit. 
This way, by changing the HEAD into something that fits the image, my repository will be attached and repository will be able to perform commits and all regular operations.

I'm active when: 
	- working copy is detached 
	- repository HEAD is detached
"
Class {
	#name : 'PulsarRepositoryRepairCheckoutNewBranch',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairCheckoutNewBranch class >> help [
	^ 'It creates a new branch from the commit your image is pointing to.
This will not lose any change in the image.

This situation happens because the code loaded in your image does not correspond with the status of your repository.

This operation will modify the state of your working copy on disk. All non-committed changes in your disk working copy that are not in the image will be lost (this can happen if you edited the repository from outside). If you want to keep them, perform a commit from outside before.'
]

{ #category : 'accessing' }
PulsarRepositoryRepairCheckoutNewBranch class >> icon [
	^ self iconNamed: #smallNew
]

{ #category : 'testing' }
PulsarRepositoryRepairCheckoutNewBranch class >> isAvailableFor: aRepository [
	"matches if: 
		- workingCopy is detached
		- HEAD is detached"
	
	aRepository isMissing ifTrue: [ ^ false ].
	aRepository workingCopy referenceCommit isUnknownCommit ifTrue: [ ^ false ].
	aRepository workingCopy referenceCommit isNoCommit ifTrue: [ ^ false ].
	
	^ aRepository workingCopy isDetached or: [ aRepository head isDetached ]
]

{ #category : 'accessing' }
PulsarRepositoryRepairCheckoutNewBranch class >> order [
	^ 10
]

{ #category : 'accessing' }
PulsarRepositoryRepairCheckoutNewBranch class >> title [
	^ 'Create a new branch pointing to your image commit'
]

{ #category : 'executing' }
PulsarRepositoryRepairCheckoutNewBranch >> basicExecute [
	| branchName |
	"Fetching remotes is necessary in case the current image commit is not 
	 in the repository. Could be optimized"
	
	self fetchAllRemotes.
	
	branchName := self application newRequest
		title: 'Create branch';
		message: 'Branch name';
		acceptLabel: 'Create';
		openModalWithParent: context window.
	branchName ifNil: [ ^ self ].
	branchName := branchName trimBoth.
	branchName ifEmpty: [ ^ self ].
	(branchName anySatisfy: #isSeparator) ifTrue: [
		self application newInform
			title: 'Invalid branch name';
			message: 'You can''t have spaces in your branch name.';
			openModalWithParent: context window.
		^ self ].

	IceTipStandardAction new
		repository: self repository;
		message: ('Checking out new branch {1}' format: { branchName });
		onSuccessRepositoryModified;
		action: [ 
			self repository 
				createBranch: branchName 
				inCommit: self repository workingCopy referenceCommit ];
		executeWithContext: context
]
