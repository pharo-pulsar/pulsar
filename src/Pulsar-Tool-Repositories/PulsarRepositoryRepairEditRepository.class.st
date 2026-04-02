"
I will open the edit repository window.

I'm active when: 
	- src subdirectory is not found.
"
Class {
	#name : 'PulsarRepositoryRepairEditRepository',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairEditRepository class >> help [
	^ 'You can edit the repository to inform another subdirectory name. 
Once the new subdirectory is updated, the packages in the repository are available.
This action does not affect the changes in the disk working copy nor in the image.

This happens because the source code directory has been moved or renamed.
'
]

{ #category : 'accessing' }
PulsarRepositoryRepairEditRepository class >> icon [
	^ self iconNamed: #edit
]

{ #category : 'testing' }
PulsarRepositoryRepairEditRepository class >> isAvailableFor: aRepository [

	^ aRepository isMissing not and: [aRepository isCodeMissing]
]

{ #category : 'accessing' }
PulsarRepositoryRepairEditRepository class >> order [
	^ 17
]

{ #category : 'accessing' }
PulsarRepositoryRepairEditRepository class >> title [
	^ 'Edit the repository to select the correct code subdirectory'
]

{ #category : 'executing' }
PulsarRepositoryRepairEditRepository >> basicExecute [

	((PulsarRepositoryProjectDialog
		newApplication: context application
		model: self repositoryModel entity project)
			onAccept: [ :dialog | self notifyRepositoryModified ];
			asModalWindow)
				owner: context window;
				open
]
