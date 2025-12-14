Class {
	#name : 'DockProjectRenameModel',
	#superclass : 'DockModelVisitor',
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'visiting' }
DockProjectRenameModel >> visitClassModel: aClassModel [

	(ReRenameClassDriver newApplication: self owner application) 
		oldName: aClassModel name;
		model: RBBrowserEnvironment new;
		scopes: { RBBrowserEnvironment new };
		runRefactoring

]
