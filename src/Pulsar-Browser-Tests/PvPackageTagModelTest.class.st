Class {
	#name : 'PvPackageTagModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PvPackageTagModelTest >> packageTagModel [
	| package tag |

	package := PackageOrganizer default packageNamed: 'Kernel'.
	tag := (package instVarNamed: #tags) anyOne.
	^ PvPackageTagModel newEnvironment: self environmentModel entity: tag
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
