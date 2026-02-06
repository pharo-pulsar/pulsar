Class {
	#name : 'PulsarRefactorPackageContext',
	#superclass : 'PulsarRefactorActionContext',
	#category : 'Pulsar-Browser-View-Refactoring',
	#package : 'Pulsar-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'refactors' }
PulsarRefactorPackageContext >> doRenamePackage: aPackageModel [

	self schedule: [
		| newName |
		
		newName := self application newRequest
			title: 'Rename package';
			message: ('Enter new name for {1}' format: { aPackageModel name });
			text: aPackageModel name;
			openModal.	
		(newName isNotNil 
			and: [ newName ~= aPackageModel name ])
			ifTrue: [ 
				"this will throw a PackageRenamed announcement"
				aPackageModel renameTo: newName.
				self flag: #TODO. "there is a problem with this: if this is contained into a project, 
				we need to affect also the baseline, which is not done for the moment" ] ]
]
