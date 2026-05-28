Class {
	#name : 'PvPackageModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PvPackageModelTest >> packageModel [

	^ PvPackageModel newEnvironment: self environmentModel entity: (PackageOrganizer default packageNamed: 'Kernel')
]

{ #category : 'tests - parent-child' }
PvPackageModelTest >> testChildrenReturnsTagModels [
	| model children |

	model := self packageModel.
	children := model children.
	self assert: children isNotNil.
	self deny: children isEmpty.
	self assert: (children allSatisfy: [ :each | each isKindOf: PvBaseModel ])
]

{ #category : 'tests - entity' }
PvPackageModelTest >> testClassesReturnsClassModels [
	| model classes |

	model := self packageModel.
	classes := model classes.
	self assert: (classes allSatisfy: [ :each | each isKindOf: PvClassModel ])
]

{ #category : 'tests - ui' }
PvPackageModelTest >> testIconName [
	| model |

	model := self packageModel.
	self assert: model iconName equals: #package
]

{ #category : 'tests - predicates' }
PvPackageModelTest >> testIsPackageReturnsTrue [
	| model |

	model := self packageModel.
	self assert: model isPackage
]

{ #category : 'tests - accessing' }
PvPackageModelTest >> testNameIsPackageName [
	| model |

	model := self packageModel.
	self assert: model name equals: 'Kernel'
]
