"
I'm a repair action to locate the directory were a repository resides.

I'm active when repository can not be located in disk.

Notice that doing this can lead you to another situation that needs repair (like a detached status)
"
Class {
	#name : 'PulsarRepositoryRepairLocateRepository',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairLocateRepository class >> help [
	^ 'Locate this repository in your file system.

This situation happens when iceberg cannot find the repository in disk.

This action will very probably let you in a detached status, because this only changes the location of the repository, but it does not affect the current commit (HEAD) or the current branch.
You will need to re-synchronize your repository with another repair action.

This happens if the repository has been removed from the disk or the image was pointing to a repository in another machine (For example, when sharing images with other machines / people).'
]

{ #category : 'accessing' }
PulsarRepositoryRepairLocateRepository class >> icon [
	^ self iconNamed: #folder
]

{ #category : 'testing' }
PulsarRepositoryRepairLocateRepository class >> isAvailableFor: aRepository [
	"active when there is no repository directory"
	
	^ aRepository isMissing
]

{ #category : 'accessing' }
PulsarRepositoryRepairLocateRepository class >> order [
	^ 10
]

{ #category : 'accessing' }
PulsarRepositoryRepairLocateRepository class >> title [
	^ 'Locate this repository in your file system'
]

{ #category : 'executing' }
PulsarRepositoryRepairLocateRepository >> basicExecute [
	| dialog |
	
	dialog := (PulsarRepositoryLocateDialog newApplication: context application)
		location: (self repository location ifNil: [ self defaultLocation ]);
		yourself.

	(dialog asModalWindow
		owner: context window;
		open) isOk ifFalse: [ ^ self ].

	self repositoryModel updateLocation: dialog location
]

{ #category : 'private' }
PulsarRepositoryRepairLocateRepository >> defaultLocation [
	^ IceLibgitRepository repositoriesLocation
]

{ #category : 'executing' }
PulsarRepositoryRepairLocateRepository >> defaultSubdirectory [
	^ IceLibgitRepository defaultCodeSubdirectory
]
