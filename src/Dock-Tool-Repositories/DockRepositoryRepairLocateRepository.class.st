"
I'm a repair action to locate the directory were a repository resides.

I'm active when repository can not be located in disk.

Notice that doing this can lead you to another situation that needs repair (like a detached status)
"
Class {
	#name : 'DockRepositoryRepairLocateRepository',
	#superclass : 'DockRepositoryRepairAction',
	#category : 'Dock-Tool-Repositories-Repair',
	#package : 'Dock-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
DockRepositoryRepairLocateRepository class >> help [
	^ 'Locate this repository in your file system.

This situation happens when iceberg cannot find the repository in disk.

This action will very probably let you in a detached status, because this only changes the location of the repository, but it does not affect the current commit (HEAD) or the current branch.
You will need to re-synchronize your repository with another repair action.

This happens if the repository has been removed from the disk or the image was pointing to a repository in another machine (For example, when sharing images with other machines / people).'
]

{ #category : 'accessing' }
DockRepositoryRepairLocateRepository class >> icon [
	^ self iconNamed: #folder
]

{ #category : 'testing' }
DockRepositoryRepairLocateRepository class >> isAvailableFor: aRepository [
	"active when there is no repository directory"
	
	^ aRepository isMissing
]

{ #category : 'accessing' }
DockRepositoryRepairLocateRepository class >> order [
	^ 10
]

{ #category : 'accessing' }
DockRepositoryRepairLocateRepository class >> title [
	^ 'Locate this repository in your file system'
]

{ #category : 'executing' }
DockRepositoryRepairLocateRepository >> basicExecute [
	| dialog |
	
	dialog := (IceTipLocalRepositoryPanel newApplication: context application)
		location: (self repository location ifNil: [ self defaultLocation ]);
		yourself.
	
	dialog asDialogWindow 
		okAction: [ 
			dialog validate.
			self repositoryModel updateLocation: dialog location.
			true ];
		open.
]

{ #category : 'private' }
DockRepositoryRepairLocateRepository >> defaultLocation [
	^ IceLibgitRepository repositoriesLocation
]

{ #category : 'executing' }
DockRepositoryRepairLocateRepository >> defaultSubdirectory [
	^ IceLibgitRepository defaultCodeSubdirectory
]
