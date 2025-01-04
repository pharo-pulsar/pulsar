Class {
	#name : 'PvPackageTagModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Package-Model',
	#package : 'Perspective-Package',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvPackageTagModel class >> newPackageTag: aPackageTag [

	^ self new 
		tag: aPackageTag;
		yourself
]

{ #category : 'accessing' }
PvPackageTagModel class >> order [

	^ 100
]

{ #category : 'accessing' }
PvPackageTagModel >> children [

	^ PvClassHierarchyBuilder buildFrom: self classes
]

{ #category : 'accessing' }
PvPackageTagModel >> classDefinitionString [
	
	^ PvFluidClassDefinitionPrinter new 
		classDefinitionTemplateInPackage: self package name
		tag: (self entity isRoot 
			ifTrue: [ nil ]
			ifFalse: [ self name ])
]

{ #category : 'accessing' }
PvPackageTagModel >> classes [

	^ (self entity classes
		collect: [ :each | PvClassModel newEnvironment: self environmentModel entity: each ]
		as: OrderedCollection)
		sorted: #name ascending
]

{ #category : 'accessing' }
PvPackageTagModel >> iconName [

	^ 'tag'
]

{ #category : 'testing' }
PvPackageTagModel >> isPackageTag [

	^ true
]

{ #category : 'testing' }
PvPackageTagModel >> isRoot [

	^ self entity isRoot
]

{ #category : 'accessing' }
PvPackageTagModel >> name [

	^ self entity name
]

{ #category : 'accessing' }
PvPackageTagModel >> order [

	^ self class order
]

{ #category : 'accessing' }
PvPackageTagModel >> package [

	^ self entity package
]
