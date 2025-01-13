Class {
	#name : 'PvPackageModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Package-Model',
	#package : 'Perspective-Package',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvPackageModel class >> newPackage: aPackage [

	^ self new 
		package: aPackage;
		yourself
]

{ #category : 'accessing' }
PvPackageModel >> children [

	^ (((self entity tags
		reject: [ :each | each name = self name ]) 
		collect: [ :each | PvPackageTagModel newEnvironment: self environmentModel entity: each ]
		as: OrderedCollection)
		addAll: ((PvVirtualPackageTagModel 
			virtualModelsFor: self entity)
			collect: [ :each | 
				each 
					newEnvironment: self environmentModel 
					entity: self entity ]);
		sorted: #order ascending, #name ascending)
		yourself
]

{ #category : 'helpers' }
PvPackageModel >> classDefinitionString [
	
	^ PvFluidClassDefinitionPrinter new 
		classDefinitionTemplateInPackage: self name
		tag: nil
]

{ #category : 'accessing' }
PvPackageModel >> classes [

	^ self entity definedClasses
		collect: [ :each | PvClassModel newEnvironment: self environmentModel entity: each ]
		as: OrderedCollection
]

{ #category : 'accessing' }
PvPackageModel >> iconName [

	^ #package
	
]

{ #category : 'testing' }
PvPackageModel >> isPackage [

	^ true
]

{ #category : 'accessing' }
PvPackageModel >> name [

	^ self entity name
]

{ #category : 'helpers' }
PvPackageModel >> traitDefinitionString [
	
	^ PvFluidClassDefinitionPrinter new 
		traitDefinitionTemplateInPackage: self name
		tag: nil
]
