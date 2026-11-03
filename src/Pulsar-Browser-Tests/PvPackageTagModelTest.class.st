Class {
	#name : 'PvPackageTagModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PvPackageTagModelTest >> packageTagModel [

	| package |
	package := self environmentModel packageNamed: 'Kernel'.
	^ PvPackageTagModel newEnvironment: self environmentModel entity: package tags anyOne
]

{ #category : 'tests - predicates' }
PvPackageTagModelTest >> testIsPackageTagReturnsTrue [
	| model |

	model := self packageTagModel.
	self assert: model isPackageTag
]

{ #category : 'tests - predicates' }
PvPackageTagModelTest >> testIsRootForRootTag [
	| model |

	model := self packageTagModel.
	self assert: (model respondsTo: #isRoot)
]

{ #category : 'tests - accessing' }
PvPackageTagModelTest >> testNameIsTagName [
	| model |

	model := self packageTagModel.
	self assert: model name isNotNil
]
