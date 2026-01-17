Class {
	#name : 'PulsarRefactorClassContext',
	#superclass : 'PulsarRefactorContext',
	#category : 'Pulsar-Browser-View-Refactoring',
	#package : 'Pulsar-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'refactors' }
PulsarRefactorClassContext >> doDuplicateClass: aClassModel [

	self scheduleTask: [
			(ReDuplicateClassDriver newApplication: self application)
				className: aClassModel name asSymbol;
				scopes: { RBBrowserEnvironment new };
				runRefactoring ]
]

{ #category : 'refactors' }
PulsarRefactorClassContext >> doRemoveClass: aClassModel [

	self flag: #TODO. "Verify which system events are triggered on this" 
	self schedule: [
		(ReRemoveClassDriver newApplication: self application) 
			scopes: { RBBrowserEnvironment new } classes: { aClassModel entity };
			model: RBBrowserEnvironment new;
			runRefactoring ]
]

{ #category : 'refactors' }
PulsarRefactorClassContext >> doRenameClass: aClassModel [

	self flag: #TODO. "Verify which system events are triggered on this"
	self scheduleTask: [
			(ReRenameClassDriver newApplication: self owner application)
				oldName: aClassModel name asSymbol;
				model: RBBrowserEnvironment new;
				scopes: { RBBrowserEnvironment new };
				runRefactoring ]
]
