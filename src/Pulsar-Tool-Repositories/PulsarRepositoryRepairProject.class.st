"
I'm an action to repair a project, which is useful when it answers true to #isUnborn.
"
Class {
	#name : 'PulsarRepositoryRepairProject',
	#superclass : 'PulsarRepositoryRepairAction',
	#category : 'Pulsar-Tool-Repositories-Repair',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Repair'
}

{ #category : 'accessing' }
PulsarRepositoryRepairProject class >> help [
	^ 'Edit the repository to add project meta-data.
This action will create a .project file in the root of your repository adding meta information such as source code directory, project name, format and so on.

This situation happens because your project does not have project meta-data and Iceberg does not know how to correctly interpret its data.'
]

{ #category : 'accessing' }
PulsarRepositoryRepairProject class >> icon [
	^ self iconNamed: #config
]

{ #category : 'testing' }
PulsarRepositoryRepairProject class >> isAvailableFor: aRepository [
	"matches if: 
		- workingCopy is atached
		- workingCopy project isUnborn"
	
	^ aRepository isMissing not  
		and: [  aRepository workingCopy isDetached not
			and: [ aRepository head isDetached not
				and: [ aRepository workingCopy project isUnborn ] ] ]
]

{ #category : 'accessing' }
PulsarRepositoryRepairProject class >> order [
	^ 30
]

{ #category : 'accessing' }
PulsarRepositoryRepairProject class >> title [
	^ 'Create project meta-data'
]

{ #category : 'executing' }
PulsarRepositoryRepairProject >> basicExecute [

	((PulsarRepositoryProjectDialog
		newApplication: context application
		model: (IceBasicProject onRepository: self repositoryModel entity))
			onAccept: [ :dialog | self notifyRepositoryModified ];
			asModalWindow)
				owner: context window;
				open
]
