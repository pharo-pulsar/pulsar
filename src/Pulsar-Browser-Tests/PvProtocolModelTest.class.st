Class {
	#name : 'PvProtocolModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'running' }
PvProtocolModelTest >> protocolModel [
	| protocol |

	protocol := Object class protocols first.
	^ PvProtocolModel newEnvironment: self environmentModel entity: protocol
]

{ #category : 'tests - predicates' }
PvProtocolModelTest >> testIsExtensionReturnsFalseForRegularProtocol [
	| model |

	model := self protocolModel.
	self deny: model isExtension
]

{ #category : 'tests - predicates' }
PvProtocolModelTest >> testIsVirtualReturnsFalse [
	| model |

	model := self protocolModel.
	self deny: model isVirtual
]

{ #category : 'tests - accessing' }
PvProtocolModelTest >> testName [
	| model |

	model := self protocolModel.
	self assert: model name isNotNil.
	self assert: (model name isKindOf: Symbol)
]

{ #category : 'tests - accessing' }
PvProtocolModelTest >> testNumberOfMethods [
	| model |

	model := self protocolModel.
	self assert: model numberOfMethods > 0
]
