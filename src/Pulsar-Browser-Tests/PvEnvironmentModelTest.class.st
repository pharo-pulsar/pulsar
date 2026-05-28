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

	model := PvEnvironmentModel onSystem.
	self assert: model allBehaviors isNotEmpty
]

{ #category : 'tests - entity' }
PvEnvironmentModelTest >> testAllPackagesNotEmpty [
	| model |

	model := PvEnvironmentModel onSystem.
	self assert: model allPackages isNotEmpty
]

{ #category : 'tests - predicates' }
PvEnvironmentModelTest >> testCannotBeRemovedOrRenamed [
	| model |

	model := PvEnvironmentModel onSystem.
	self deny: model canBeRemoved.
	self deny: model canBeRenamed
]

{ #category : 'tests - parent-child' }
PvEnvironmentModelTest >> testChildrenReturnsPackages [
	| model children |

	model := PvEnvironmentModel onSystem.
	children := model children.
	self assert: children isNotEmpty.
	self assert: (children allSatisfy: [ :each | each isKindOf: PvPackageModel ])
]

{ #category : 'tests - entity' }
PvEnvironmentModelTest >> testClassNamed [
	| model |

	model := PvEnvironmentModel onSystem.
	self assert: (model classNamed: #Object) equals: Object
]

{ #category : 'tests - entity' }
PvEnvironmentModelTest >> testClassesMatching [
	| model results |

	model := PvEnvironmentModel onSystem.
	results := model classesMatching: 'Object'.
	self assert: (results includes: Object)
]

{ #category : 'tests - environment' }
PvEnvironmentModelTest >> testEnvironmentModelReturnsSelf [
	| model |

	model := PvEnvironmentModel onSystem.
	self assert: model environmentModel equals: model
]

{ #category : 'tests - entity' }
PvEnvironmentModelTest >> testHasPackageNamed [
	| model |

	model := PvEnvironmentModel onSystem.
	self assert: (model hasPackageNamed: 'Kernel')
]

{ #category : 'tests - accessing' }
PvEnvironmentModelTest >> testIconName [
	| model |

	model := PvEnvironmentModel onSystem.
	self assert: model iconName equals: 'systemEnvironment'
]

{ #category : 'tests - accessing' }
PvEnvironmentModelTest >> testName [
	| model |

	model := PvEnvironmentModel onSystem.
	self assert: model name isNotNil.
	self assert: model name isString
]

{ #category : 'tests - creation' }
PvEnvironmentModelTest >> testNewMultiProjectModel [
	| model projectModel |

	model := PvEnvironmentModel onSystem.
	projectModel := model newMultiProjectModel.
	self assert: (projectModel isKindOf: PulsarMultiProjectModel)
]

{ #category : 'tests - creation' }
PvEnvironmentModelTest >> testOnSystemCreatesModel [
	| model |

	model := PvEnvironmentModel onSystem.
	self assert: (model isKindOf: PvEnvironmentModel).
	self assert: model entity isNotNil
]
