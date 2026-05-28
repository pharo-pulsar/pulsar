Class {
	#name : 'PvTreeNodeModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests - predicates' }
PvTreeNodeModelTest >> testCannotBeRemovedOrRenamed [
	| model |

	model := PvTreeNodeModel newEnvironment: self environmentModel.
	self deny: model canBeRemoved.
	self deny: model canBeRenamed
]

{ #category : 'tests - parent-child' }
PvTreeNodeModelTest >> testChildrenAccessors [
	| model child1 child2 |

	model := PvTreeNodeModel newEnvironment: self environmentModel.
	child1 := PvTreeNodeModel newEnvironment: self environmentModel.
	child1 name: 'Child1'.
	child2 := PvTreeNodeModel newEnvironment: self environmentModel.
	child2 name: 'Child2'.

	model children: {
			child1.
			child2 }.
	self assert: model children size equals: 2.
	self assert: model children first name equals: 'Child1'.
	self assert: model children second name equals: 'Child2'
]

{ #category : 'tests - ui' }
PvTreeNodeModelTest >> testIconNameAccessors [
	| model |

	model := PvTreeNodeModel newEnvironment: self environmentModel.
	model iconName: #testIcon.
	self assert: model iconName equals: #testIcon
]

{ #category : 'tests - accessing' }
PvTreeNodeModelTest >> testNameAccessors [
	| model |

	model := PvTreeNodeModel newEnvironment: self environmentModel.
	model name: 'Root'.
	self assert: model name equals: 'Root'
]
