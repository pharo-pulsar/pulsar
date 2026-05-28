Class {
	#name : 'PvClassModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PvClassModelTest >> classModel [

	^ PvClassModel newEnvironment: self environmentModel entity: Object
]

{ #category : 'tests - creation' }
PvClassModelTest >> testBeForNewClass [
	| model |

	model := self classModel.
	model beForNewClass.
	self assert: model isNew
]

{ #category : 'tests - accessing' }
PvClassModelTest >> testFullName [
	| model |

	model := self classModel.
	self assert: model fullName equals: 'Object'
]

{ #category : 'tests - environment' }
PvClassModelTest >> testIncludesClassModel [
	| model |

	model := self classModel.
	self assert: model includesClassModel
]

{ #category : 'tests - accessing' }
PvClassModelTest >> testInstanceSideAndClassSide [
	| model |

	model := self classModel.
	self assert: model instanceSide equals: Object.
	self assert: model classSide equals: Object class
]

{ #category : 'tests - predicates' }
PvClassModelTest >> testIsClassModelReturnsTrue [
	| model |

	model := self classModel.
	self assert: model isClassModel
]

{ #category : 'tests - predicates' }
PvClassModelTest >> testIsNewDefaultsToFalse [
	| model |

	model := self classModel.
	self deny: model isNew
]

{ #category : 'tests - predicates' }
PvClassModelTest >> testIsTestCaseDetectsTestCase [
	| model |

	model := PvClassModel newEnvironment: self environmentModel entity: PvBaseModelTest.
	self assert: model isTestCase
]

{ #category : 'tests - accessing' }
PvClassModelTest >> testNameIsClassName [
	| model |

	model := self classModel.
	self assert: model name equals: 'Object'
]

{ #category : 'tests - accessing' }
PvClassModelTest >> testPackageName [
	| model |

	model := self classModel.
	self assert: model packageName equals: 'Kernel'
]
