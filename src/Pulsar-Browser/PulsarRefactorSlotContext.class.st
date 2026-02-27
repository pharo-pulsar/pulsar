Class {
	#name : 'PulsarRefactorSlotContext',
	#superclass : 'PulsarRefactorActionContext',
	#category : 'Pulsar-Browser-View-Refactoring',
	#package : 'Pulsar-Browser',
	#tag : 'View-Refactoring'
}

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
