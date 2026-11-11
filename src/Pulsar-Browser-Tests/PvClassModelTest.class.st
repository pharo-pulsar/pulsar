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

{ #category : 'tests' }
PvClassModelTest >> testInstanceSideAndClassSide [

	| model |
	model := self classModel.
	self assert: model instanceSide name equals: 'Object'.
	self assert: model classSide name equals: 'Object class'
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

{ #category : 'tests' }
PvClassModelTest >> testIsTestCaseDetectsTestCase [

	| model |
	model := PvClassModel newEnvironment: self environmentModel entity: TestCase.
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

{ #category : 'tests' }
PvClassModelTest >> testSaveCommentNormalizesLineEndings [
	"Comments arriving with LF (Gtk text buffers) must be stored with CR, like Pharo and Tonel expect."

	| model originalComment |
	model := self classModel.
	originalComment := model entity comment.
	[
		model saveComment: 'first line' , String lf , 'second line' , String cr , 'third line'.
		self assert: model entity comment equals: 'first line' , String cr , 'second line' , String cr , 'third line' ] ensure: [
		model entity comment: originalComment ]
]

{ #category : 'tests' }
PvClassModelTest >> testSaveCommentWithSameContentAndDifferentLineEndingsKeepsCommentEqual [
	"Saving the same text again with different line endings must not alter the stored comment."

	| model originalComment |
	model := self classModel.
	originalComment := model entity comment.
	[
		model saveComment: 'same' , String cr , 'content'.
		model saveComment: 'same' , String lf , 'content'.
		self assert: model entity comment equals: 'same' , String cr , 'content' ] ensure: [ model entity comment: originalComment ]
]
