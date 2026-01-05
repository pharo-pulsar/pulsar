Class {
	#name : 'DockRefactorMethodContext',
	#superclass : 'DockRefactorContext',
	#category : 'Dock-Browser-View-Refactoring',
	#package : 'Dock-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'refactoring' }
DockRefactorMethodContext >> doPullUpMethod: aMethodModel [
	
	self schedule: [
		(RePullUpMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pullUpMethods: { aMethodModel entity };
			runRefactoring ]	
]

{ #category : 'refactoring' }
DockRefactorMethodContext >> doPushUpMethod: aMethodModel [


	self schedule: [
		(RePullUpMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pullUpMethods: { aMethodModel entity };
			runRefactoring ]
]

{ #category : 'refactoring' }
DockRefactorMethodContext >> doRenameMethod: aMethodModel [

	self schedule: [ 
		| rbClasses rbModel method |
		
		method := aMethodModel entity.
		rbClasses := RBClassEnvironment classes: method methodClass withAllSubclasses.
		rbModel := RBNamespace onEnvironment: rbClasses.
		(ReRenameMethodDriver newApplication: self application)
			scopes: { rbClasses }
				model: rbModel
				renameMethodSignature: method
				in: method methodClass;
			runRefactoring ]
]
