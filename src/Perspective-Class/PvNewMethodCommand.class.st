Class {
	#name : #PvNewMethodCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-Command'
}

{ #category : #initialization }
PvNewMethodCommand >> defineAction [

	self priority: 10.
	self name: 'Add method'.
	self description: 'Add a method to current class/trait'.
	self iconComposite: (PvCompositeIcon new 
		name: 'add';
		topRight: 'overlayClass';
		bottomRight: 'overlayMethod';
		yourself).
	self menuGroup: #action
]

{ #category : #executing }
PvNewMethodCommand >> execute [
	| parentModel |

	parentModel := context model.
	context activateWith: (PvMethodModel
		newEnvironment: self model environmentModel
		entity: (PvNewMethodTemplate new
			parentModel: parentModel;
			yourself))	
]
