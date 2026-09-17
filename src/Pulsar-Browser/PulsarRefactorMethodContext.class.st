Class {
	#name : 'PulsarRefactorMethodContext',
	#superclass : 'PulsarRefactorActionContext',
	#category : 'Pulsar-Browser-View-Refactoring',
	#package : 'Pulsar-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doAddParameter: aMethodModel [

	self scheduleTask: [
		| rbClasses rbModel method |
		
		method := aMethodModel entity.
		rbClasses := RBClassEnvironment classes: method methodClass withAllSubclasses.
		rbModel := RBNamespace onEnvironment: rbClasses.

		(ReAddParameterDriver newApplication: self application)
			scopes: { RBBrowserEnvironment new. rbClasses }
				model: rbModel
				addParameterToMethodSignature: method
				in: method methodClass;
			runRefactoring ]
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doMoveToClassSide: aMethodModel [

	self scheduleTask: [
		(ReMoveMethodsToClassSideDriver newApplication: self application)
			scopes: { RBBrowserEnvironment new } methods: { aMethodModel entity };
			runRefactoring ]
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doMoveToInstanceSide: aMethodModel [

	self scheduleTask: [
		(ReMoveMethodToClassDriver newApplication: self application)
			scopes: { RBBrowserEnvironment new } 
				method: aMethodModel entity 
				class: aMethodModel methodClass;
			runRefactoring ]
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doPullUpMethod: aMethodModel [

	self scheduleTask: [
		(RePullUpMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pullUpMethods: { aMethodModel entity };
			runRefactoring ]
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doPushDownInSomeClassesMethod: aMethodModel [

	self scheduleTask: [
		(RePushDownMethodInSomeClassesDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pushDownMethods: { aMethodModel entity };
			runRefactoring ]
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doPushDownMethod: aMethodModel [

	self scheduleTask: [
		(RePushDownMethodDriver newApplication: self application)
			model: (RBNamespace onEnvironment: RBBrowserEnvironment new)
				scopes: { RBBrowserEnvironment new }
				pushDownMethods: { aMethodModel entity };
			runRefactoring ]
]

{ #category : 'refactoring' }
PulsarRefactorMethodContext >> doRemoveParameter: aMethodModel [

	self scheduleTask: [
		| rbClasses rbModel method |

		method := aMethodModel entity.
		rbClasses := RBClassEnvironment classes: method methodClass withAllSubclasses.
		rbModel := RBNamespace onEnvironment: rbClasses.

		(ReRemoveParameterDriver newApplication: self application)
			scopes: {
				RBBrowserEnvironment new.
				rbClasses }
			model: rbModel
			removeParameterFromMethodSignature: method
			in: method methodClass;
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
			scopes: { RBBrowserEnvironment new. rbClasses }
				model: rbModel
				renameMethodSignature: method
				in: method methodClass;
			runRefactoring ]
]
