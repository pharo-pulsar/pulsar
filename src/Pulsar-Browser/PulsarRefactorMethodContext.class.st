Class {
	#name : 'PulsarRefactorMethodContext',
	#superclass : 'PulsarRefactorContext',
	#category : 'Pulsar-Browser-View-Refactoring',
	#package : 'Pulsar-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doPullUpMethod: aMethodModel [
	
	self schedule: [
		(RePullUpMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pullUpMethods: { aMethodModel entity };
			runRefactoring ]	
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doPushUpMethod: aMethodModel [

	self schedule: [
		(RePullUpMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pullUpMethods: { aMethodModel entity };
			runRefactoring ]
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doRenameMethod: aMethodModel [

	self scheduleTask: [
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
