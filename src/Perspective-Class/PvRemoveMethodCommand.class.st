Class {
	#name : #PvRemoveMethodCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #initialization }
PvRemoveMethodCommand >> defineAction [

	self priority: 10.
	self name: 'Remove method'.
	self description: 'Remove a method from current class/trait'.
	self iconComposite: (PvCompositeIcon new 
		name: 'trash';
		bottomRight: 'overlayMethod';
		yourself)
]

{ #category : #executing }
PvRemoveMethodCommand >> execute [
	| parentModel |

	parentModel := context model.
	context activateWith: (PvMethodModel
		newEnvironment: self model environmentModel
		entity: (PvNewMethodTemplate new
			parentModel: parentModel;
			yourself))	
]
