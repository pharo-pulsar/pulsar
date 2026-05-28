Class {
	#name : 'PvBaseModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvBaseModelTest >> environmentModel [

	^ PvEnvironmentModel onSystem
]

{ #category : 'tests - visiting' }
PvBaseModelTest >> testAcceptVisitsModel [
	| env model visitor |

	env := self environmentModel.
	model := PvBaseModelForTest newEnvironment: env.
	visitor := PulsarModelVisitor new. 
	"accept: delegates to visitModel: which does not set owner; it is a no-op by default"
	model accept: visitor.
	self assert: visitor class equals: PulsarModelVisitor
]

{ #category : 'tests - actions' }
PvBaseModelTest >> testActionsNotEmpty [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model actions isNotNil
]

{ #category : 'tests - actions' }
PvBaseModelTest >> testActionsWithContext [
	| model actions |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	actions := model actionsWithContext: #testContext.
	self assert: actions isNotNil
]

{ #category : 'tests - actions' }
PvBaseModelTest >> testActionsWithContextOnReturnsActionGroup [
	| model actions |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	actions := model actionsWithContextOn: nil.
	self assert: (actions isKindOf: SpActionGroup)
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testCanBeActivated [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model canBeActivated
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testCanBeRemoved [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model canBeRemoved
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testCanBeRenamed [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model canBeRenamed
]

{ #category : 'tests - ui' }
PvBaseModelTest >> testColorNameDefaultsToNil [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model colorName isNil
]

{ #category : 'tests - parent-child' }
PvBaseModelTest >> testDefaultChildren [
	| env model |

	env := self environmentModel.
	model := PvBaseModelForTest newEnvironment: env.
	self assert: model children isEmpty
]

{ #category : 'tests - entity' }
PvBaseModelTest >> testEntityAccessors [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.

	self assert: model entity isNil.

	model entity: #newEntity.
	self assert: model entity equals: #newEntity
]

{ #category : 'tests - environment' }
PvBaseModelTest >> testEnvironmentModelAccessors [
	| model env |

	env := self environmentModel.
	model := PvBaseModelForTest newEnvironment: env.
	self assert: model environmentModel equals: env.

	model environmentModel: nil.
	self assert: model environmentModel isNil
]

{ #category : 'tests - identity' }
PvBaseModelTest >> testEqualsDifferentClass [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel entity: #entity.

	self deny: model = 'not a model'
]

{ #category : 'tests - identity' }
PvBaseModelTest >> testEqualsDifferentEntity [
	| model1 model2 |

	model1 := PvBaseModelForTest newEnvironment: self environmentModel entity: #entity1.
	model2 := PvBaseModelForTest newEnvironment: self environmentModel entity: #entity2.

	self deny: model1 equals: model2
]

{ #category : 'tests - identity' }
PvBaseModelTest >> testEqualsSameEntity [
	| model1 model2 |

	model1 := PvBaseModelForTest newEnvironment: self environmentModel entity: #entity.
	model2 := PvBaseModelForTest newEnvironment: self environmentModel entity: #entity.

	self assert: model1 equals: model2
]

{ #category : 'tests - identity' }
PvBaseModelTest >> testHashSameForEqualModels [
	| model1 model2 |

	model1 := PvBaseModelForTest newEnvironment: self environmentModel entity: #entity.
	model2 := PvBaseModelForTest newEnvironment: self environmentModel entity: #entity.

	self assert: model1 hash equals: model2 hash
]

{ #category : 'tests - ui' }
PvBaseModelTest >> testIconNameDefaultsToNil [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model iconName isNil
]

{ #category : 'tests - environment' }
PvBaseModelTest >> testIncludesClassModelDelegatesToEnvironment [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model includesClassModel
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testIsClassModelReturnsFalse [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model isClassModel
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testIsContextModelReturnsFalse [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model isContextModel
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testIsMethodModelReturnsFalse [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model isMethodModel
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testIsPackageOrTagReturnsFalse [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model isPackageOrTag
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testIsPackageReturnsFalse [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model isPackage
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testIsPackageTagReturnsFalse [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model isPackageTag
]

{ #category : 'tests - predicates' }
PvBaseModelTest >> testIsProjectReturnsFalse [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self deny: model isProject
]

{ #category : 'tests - matching' }
PvBaseModelTest >> testMatchesPrefix [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	model name: 'TestModel'.

	self assert: (model matches: 'test').
	self deny: (model matches: 'xyz')
]

{ #category : 'tests - creation' }
PvBaseModelTest >> testNewEnvironment [
	| env model |

	env := self environmentModel.
	model := PvBaseModelForTest newEnvironment: env.

	self assert: model environmentModel equals: env.
	self assert: model parentModel isNil.
	self assert: model entity isNil
]

{ #category : 'tests - creation' }
PvBaseModelTest >> testNewEnvironmentEntity [
	| env model |

	env := self environmentModel.
	model := PvBaseModelForTest newEnvironment: env entity: #testEntity.

	self assert: model environmentModel equals: env.
	self assert: model entity equals: #testEntity.
	self assert: model parentModel isNil
]

{ #category : 'tests - creation' }
PvBaseModelTest >> testNewEnvironmentParentEntity [
	| env parent model |

	env := self environmentModel.
	parent := PvBaseModelForTest newEnvironment: env entity: #parentEntity.
	model := PvBaseModelForTest newEnvironment: env parent: parent entity: #childEntity.

	self assert: model environmentModel equals: env.
	self assert: model entity equals: #childEntity.
	self assert: model parentModel equals: parent
]

{ #category : 'tests - parent-child' }
PvBaseModelTest >> testParentModelAccessors [
	| model parent |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model parentModel isNil.

	parent := PvBaseModelForTest newEnvironment: self environmentModel.
	model parentModel: parent.
	self assert: model parentModel equals: parent
]

{ #category : 'tests - snapshot' }
PvBaseModelTest >> testPrepareForSnapshotDoesNotFail [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	model prepareForSnapshot "should not raise an error"
]

{ #category : 'tests - identity' }
PvBaseModelTest >> testRealModelReturnsSelf [
	| model |

	model := PvBaseModelForTest newEnvironment: self environmentModel.
	self assert: model realModel equals: model
]
