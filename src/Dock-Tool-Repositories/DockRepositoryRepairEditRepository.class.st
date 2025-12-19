"
I will open the edit repository window.

I'm active when: 
	- src subdirectory is not found.
"
Class {
	#name : 'DockRepositoryRepairEditRepository',
	#superclass : 'DockRepositoryRepairAction',
	#category : 'Dock-Tool-Repositories-Repair',
	#package : 'Dock-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
DockRepositoryRepairEditRepository class >> help [
	^ 'You can edit the repository to inform another subdirectory name. 
Once the new subdirectory is updated, the packages in the repository are available.
This action does not affect the changes in the disk working copy nor in the image.

This happens because the source code directory has been moved or renamed.
'
]

{ #category : 'accessing' }
DockRepositoryRepairEditRepository class >> icon [
	^ self iconNamed: #edit
]

{ #category : 'testing' }
DockRepositoryRepairEditRepository class >> isAvailableFor: aRepository [

	^ aRepository isMissing not and: [aRepository isCodeMissing]
]

{ #category : 'accessing' }
DockRepositoryRepairEditRepository class >> order [
	^ 17
]

{ #category : 'accessing' }
DockRepositoryRepairEditRepository class >> title [
	^ 'Edit the repository to select the correct code subdirectory'
]

{ #category : 'executing' }
DockRepositoryRepairEditRepository >> basicExecute [

	(IceTipEditProjectDialogPresenter
		newApplication: context application
		model: self repositoryModel entity project)
		openDialog
]
