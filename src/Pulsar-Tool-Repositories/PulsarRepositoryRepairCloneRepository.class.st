"
I'm a repair action to clone again a repository (in case something moved).

I'm active when repository can not be located in disk.

Notice that doing this can lead you to another situation that needs repair (like a detached status)
"
Class {
	#name : 'PulsarRepositoryRepairCloneRepository',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairCloneRepository class >> help [
	^ 'Clone again the repository into a new location.

This situation happens when iceberg cannot find the repository on disk.

The cloned repository will be in the commit of the remote. 
This commit may be not the same commit that your image has.
So, this action will very probably let you in a detached status.
You will need to re-synchronize your repository with another repair action.'
]

{ #category : 'accessing' }
PulsarRepositoryRepairCloneRepository class >> icon [
	^ self iconNamed: #smallAdd
]

{ #category : 'testing' }
PulsarRepositoryRepairCloneRepository class >> isAvailableFor: aRepository [
	"active when there is no repository directory"

	^ aRepository isMissing
]

{ #category : 'accessing' }
PulsarRepositoryRepairCloneRepository class >> order [
	^ 20
]

{ #category : 'accessing' }
PulsarRepositoryRepairCloneRepository class >> title [
	^ 'Clone again this repository in a new location'
]

{ #category : 'executing' }
PulsarRepositoryRepairCloneRepository >> basicExecute [

	((IceTipRegisterRepositoryDialogPresenter newApplication: context application) 
		beForCloneOfRepository: self repositoryModel entity;
		onAccept: [ 
			Iceberg announcer announce: (IceRepositoryModified for: self repositoryModel entity) ];
		asDialogWindow)
			centeredRelativeTo: context window;
			open
]
