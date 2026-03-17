Class {
	#name : 'PulsarRefactorSlotContext',
	#superclass : 'PulsarRefactorActionContext',
	#category : 'Pulsar-Browser-View-Refactoring',
	#package : 'Pulsar-Browser',
	#tag : 'View-Refactoring'
}

{ #category : 'refactors' }
PulsarRefactorSlotContext >> doPullUpVariable: aSlotModel [

	self scheduleTask: [
		| rbClasses |
		rbClasses := RBClassHierarchyEnvironment class: aSlotModel variableClass.
		(RePushUpVariableDriver newApplication: self application)
			scopes: { rbClasses }
				variable: aSlotModel name
				shared: false
				to: aSlotModel variableClass superclass;
			runRefactoring ]
]

{ #category : 'refactors' }
PulsarRefactorSlotContext >> doPushDownVariable: aSlotModel [

	self scheduleTask: [
		| rbClasses |
		rbClasses := RBClassEnvironment classes: aSlotModel variableClass withAllSubclasses.
		(RePushDownInstanceVariableDriver newApplication: self application)
			scopes: { rbClasses };
			variables: { aSlotModel entity };
			runRefactoring ]
]

{ #category : 'refactors' }
PulsarRefactorSlotContext >> doRenameVariable: aSlotModel [

	self scheduleTask: [
		| rbClasses |
		rbClasses := RBClassEnvironment classes: { aSlotModel variableClass }.
		(ReRenameInstanceVariableDriver newApplication: self application)
			scopes: { rbClasses }
				variable: aSlotModel name
				for: aSlotModel variableClass;
			runRefactoring ]
]
