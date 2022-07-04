Class {
	#name : #PvPackageModel,
	#superclass : #PvEntityModel,
	#category : #'Perspective-Package-Model'
}

{ #category : #'instance creation' }
PvPackageModel class >> newPackage: aPackage [

	^ self new 
		package: aPackage;
		yourself
]

{ #category : #accessing }
PvPackageModel >> children [

	^ (((self entity classTags 
		reject: [ :each | each name = self name ]) 
		collect: [ :each | PvPackageTagModel newEnvironment: self environmentModel entity: each ]
		as: OrderedCollection)
		addAll: ((PvVirtualPackageTagModel virtualModelsFor: self entity) 
			collect: [ :each | each newEnvironment: self environmentModel entity: each ]);
		sorted: #order ascending, #name ascending)
		yourself
]

{ #category : #helpers }
PvPackageModel >> classDefinitionString [
	
	^ ClassDefinitionPrinter new 
		classDefinitionTemplateInPackage: self name
		tag: nil
]

{ #category : #accessing }
PvPackageModel >> classes [

	^ self entity definedClasses
		collect: [ :each | PvClassModel newEnvironment: self environmentModel entity: each ]
		as: OrderedCollection
]

{ #category : #accessing }
PvPackageModel >> iconName [

	^ #package
	
]

{ #category : #testing }
PvPackageModel >> isPackage [

	^ true
]

{ #category : #accessing }
PvPackageModel >> name [

	^ self entity packageName
]
