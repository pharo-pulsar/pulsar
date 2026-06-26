"
I am a project model not backed by a Metacello baseline. I hold an arbitrary name and a collection of package models, allowing users to organize packages without requiring a BaselineOf class.

I am useful for quick exploration, prototyping, and grouping work that does not yet warrant its own baseline.
"
Class {
	#name : 'PulsarVolatileProjectModel',
	#superclass : 'PulsarBaseProjectModel',
	#instVars : [
		'packageModels'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing' }
PulsarVolatileProjectModel >> addPackageNamed: aName [
	| package existingModel newModel spec |
	
	(self environmentModel hasPackageNamed: aName) ifTrue: [
		package := self environmentModel packageNamed: aName.
		existingModel := packageModels 
			detect: [ :each | each entity = package ] 
			ifNone: [ nil ].
		existingModel ifNotNil: [ ^ existingModel ].
		
		newModel := PvPackageModel 
			newEnvironment: self environmentModel 
			parent: self 
			entity: package.
		
		packageModels add: newModel.
		spec := PulsarVolatileProjectSpec named: self name.
		spec ifNotNil: [ spec addPackageNamed: aName ].
		
		^ newModel ].
	
	super addPackageNamed: aName.
	
	package := self environmentModel packageNamed: aName.
	newModel := PvPackageModel 
		newEnvironment: self environmentModel 
		parent: self 
		entity: package.
	
	packageModels add: newModel.
	
	spec := PulsarVolatileProjectSpec named: self name.
	spec ifNotNil: [ spec addPackageNamed: aName ].
	
	^ newModel
]

{ #category : 'accessing' }
PulsarVolatileProjectModel >> children [

	^ packageModels
]

{ #category : 'accessing' }
PulsarVolatileProjectModel >> iconName [

	^ 'project-volatile'
]

{ #category : 'initialization' }
PulsarVolatileProjectModel >> initialize [

	super initialize.
	packageModels := OrderedCollection new
]

{ #category : 'testing' }
PulsarVolatileProjectModel >> isVolatileProject [

	^ true
]

{ #category : 'accessing' }
PulsarVolatileProjectModel >> name [

	^ self entity
]

{ #category : 'accessing' }
PulsarVolatileProjectModel >> packageModels [

	^ packageModels
]
