Class {
	#name : 'PulsarRefactorClassContext',
	#superclass : 'PulsarRefactorActionContext',
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
PulsarRefactorClassContext >> doInsertSubclass: aClassModel [
	
	self scheduleTask: [
		| choiceTuple driver |

		choiceTuple := (SpSelectDialog newApplication: self application)
			title: 'Choose a way to create your new class';
			message: 'Select the strategy you want to use';
			items: {
				(false -> 'Insert your new class in between the target class and its subclasses').
				(true -> 'Add your new class as subclass of the target class and don''t change its hierarchy') };
			display: [ :each | each value ];
			openModal.
		
		choiceTuple ifNotNil: [
			driver := (ReInsertSubclassDriver newApplication: self application)
				superclass: aClassModel entity;
				packageName: aClassModel entity packageName;	
				scopes: { RBBrowserEnvironment new };
				yourself.
				
			choiceTuple key 
				ifTrue: [ driver beSibling ].
				
			driver runRefactoring ]
	]
]

{ #category : 'refactors' }
PulsarRefactorClassContext >> doInsertSuperclass: aClassModel [

	self scheduleTask: [
		(ReInsertSuperclassDriver newApplication: self application)
			superclass: aClassModel entity;
			scopes: { RBBrowserEnvironment new };
			runRefactoring ]
]

{ #category : 'refactors' }
PulsarRefactorClassContext >> doRemoveClass: aClassModel [

   self scheduleTask: [
   		| removeScope |
   		removeScope := RBBrowserEnvironment new.
	   (ReRemoveClassDriver newApplication: self application)
		   scopes: { removeScope } classes: { aClassModel entity };
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
