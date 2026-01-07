Class {
	#name : 'PulsarProjectRenameModel',
	#superclass : 'PulsarModelVisitor',
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'visiting' }
PulsarProjectRenameModel >> visitClassModel: aClassModel [

	(ReRenameClassDriver newApplication: self owner application) 
		oldName: aClassModel name;
		model: RBBrowserEnvironment new;
		scopes: { RBBrowserEnvironment new };
		runRefactoring

]
