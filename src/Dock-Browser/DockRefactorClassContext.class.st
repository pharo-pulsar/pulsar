Class {
	#name : 'DockRefactorClassContext',
	#superclass : 'DockRefactorContext',
	#category : 'Dock-Browser-View-Refactoring',
	#package : 'Dock-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'refactors' }
DockRefactorClassContext >> doDuplicateClass: aClassModel [

	self schedule: [
		(ReDuplicateClassDriver newApplication: self application)
			className: aClassModel name asSymbol;
			scopes: { RBBrowserEnvironment new };
			runRefactoring ]
]

{ #category : 'refactors' }
DockRefactorClassContext >> doRemoveClass: aClassModel [

	self flag: #TODO. "Verify which system events are triggered on this" 
	self schedule: [
		(ReRemoveClassDriver newApplication: self application) 
			scopes: { RBBrowserEnvironment new } classes: { aClassModel entity };
			model: RBBrowserEnvironment new;
			runRefactoring ]
]

{ #category : 'refactors' }
DockRefactorClassContext >> doRenameClass: aClassModel [

	self flag: #TODO. "Verify which system events are triggered on this" 
	self schedule: [
		(ReRenameClassDriver newApplication: self owner application) 
			oldName: aClassModel name asSymbol;
			model: RBBrowserEnvironment new;
			scopes: { RBBrowserEnvironment new };
			runRefactoring ]
]
