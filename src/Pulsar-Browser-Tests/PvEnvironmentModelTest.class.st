Class {
	#name : 'PvEnvironmentModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests - entity' }
PvEnvironmentModelTest >> testAllBehaviorsNotEmpty [
	| model |

	model := self environmentModel.
	self assert: model allBehaviors isNotEmpty
]

{ #category : 'tests - entity' }
PvEnvironmentModelTest >> testAllPackagesNotEmpty [
	| model |

	model := self environmentModel.
	self assert: model allPackages isNotEmpty
]

{ #category : 'tests - predicates' }
PvEnvironmentModelTest >> testCannotBeRemovedOrRenamed [
	| model |

	model := self environmentModel.
	self deny: model canBeRemoved.
	self deny: model canBeRenamed
]

{ #category : 'tests - parent-child' }
PvEnvironmentModelTest >> testChildrenReturnsPackages [
	| model children |

	model := self environmentModel.
	children := model children.
	self assert: children isNotEmpty.
	self assert: (children allSatisfy: [ :each | each isKindOf: PvPackageModel ])
]

{ #category : 'tests' }
PvEnvironmentModelTest >> testClassNamed [

	| model |
	model := self environmentModel.
	self assert: (model classNamed: #Object) name equals: 'Object'
]

{ #category : 'tests' }
PvEnvironmentModelTest >> testClassesMatching [

	| model results |
	model := self environmentModel.
	results := model classesMatching: 'Object'.
	self assert: (results anySatisfy: [ :each | each name = 'Object' ])
]

{ #category : 'tests - environment' }
PvEnvironmentModelTest >> testEnvironmentModelReturnsSelf [
	| model |

	model := self environmentModel.
	self assert: model environmentModel equals: model
]

{ #category : 'tests - entity' }
PvEnvironmentModelTest >> testHasPackageNamed [
	| model |

	model := self environmentModel.
	self assert: (model hasPackageNamed: 'Kernel')
]

{ #category : 'tests - accessing' }
PvEnvironmentModelTest >> testIconName [
	| model |

	model := self environmentModel.
	self assert: model iconName equals: 'systemEnvironment'
]

{ #category : 'tests - accessing' }
PvEnvironmentModelTest >> testName [
	| model |

	model := self environmentModel.
	self assert: model name isNotNil.
	self assert: model name isString
]

{ #category : 'tests' }
PvEnvironmentModelTest >> testNewMultiProjectModel [

	| model |
	model := self environmentModel.
	self withCleanVolatileProjects: [
		self assert: (model newMultiProjectModel isKindOf: PulsarMultiProjectModel) ]
]
