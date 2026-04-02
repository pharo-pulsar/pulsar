"
I will discard image changes and I will restore source from current repository HEAD.

I'm active when: 
	- working copy is detached 
	- repository HEAD is NOT detached
"
Class {
	#name : 'PulsarRepositoryRepairDiscardAndLoad',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairDiscardAndLoad class >> help [
	^ 'Discard all changes in your image and checkout the current commit (HEAD) in the repository.

This action will synchronize your image with the code in the repository.

All the changes in the image that have not been committed will be lost.

This situation happens because loaded code in your image is from a different commit than the current commit (HEAD) in the repository.

Opens a preview window with the incoming changes before doing any change.'
]

{ #category : 'accessing' }
PulsarRepositoryRepairDiscardAndLoad class >> icon [
	^ self iconNamed: #refresh
]

{ #category : 'testing' }
PulsarRepositoryRepairDiscardAndLoad class >> isAvailableFor: aRepository [
	"matches if: 
		- workingCopy is detached
		- HEAD is NOT detached"

	^ aRepository isMissing not  
		and: [ aRepository workingCopy isDetached 
		and: [ aRepository head isDetached not ] ]
]

{ #category : 'accessing' }
PulsarRepositoryRepairDiscardAndLoad class >> order [
	^ 40
]

{ #category : 'accessing' }
PulsarRepositoryRepairDiscardAndLoad class >> title [
	^ 'Discard image changes and load repository version'
]

{ #category : 'executing' }
PulsarRepositoryRepairDiscardAndLoad >> basicExecute [
	
	(PulsarRepositoryCheckoutWindow 
		newApplication: self application
		model: self repositoryModel)
		open
]

{ #category : 'private' }
PulsarRepositoryRepairDiscardAndLoad >> finishSuccess [
	super finishSuccess.
	self notifyRepositoryModified
]
