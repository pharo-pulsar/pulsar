"
Abstract base for test tree nodes, extending Object directly.

Slots:
- entity: the wrapped model (PulsarProjectModel, PvPackageModel, PvClassModel, PvMethodModel)
- parent: parent tree node (for three-state selection propagation)
- model: the PulsarTestRunnerModel
- stateChangedAction: callback for checkbox updates
- active: three-state selection flag
- children: cached child nodes
"
Class {
	#name : 'PulsarTestNodeModel',
	#superclass : 'Object',
	#instVars : [
		'entity',
		'parent',
		'model',
		'stateChangedAction',
		'active',
		'children'
	],
	#category : 'Pulsar-Tool-TestRunner-Model',
	#package : 'Pulsar-Tool-TestRunner',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarTestNodeModel class >> newEntity: anObject parent: aParentNode model: aTestRunnerModel [

	^ self new
		  entity: anObject;
		  parent: aParentNode;
		  model: aTestRunnerModel;
		  yourself
]

{ #category : 'accessing' }
PulsarTestNodeModel >> activationAnnouncementClass [

	^ PulsarModelActivated
]

{ #category : 'accessing' }
PulsarTestNodeModel >> active: aBoolean [

	active := aBoolean
]

{ #category : 'testing' }
PulsarTestNodeModel >> canBeActivated [

	^ self activationAnnouncementClass isNotNil
]

{ #category : 'testing' }
PulsarTestNodeModel >> canBeRemoved [

	^ false
]

{ #category : 'testing' }
PulsarTestNodeModel >> canBeRenamed [

	^ false
]

{ #category : 'accessing' }
PulsarTestNodeModel >> children [

	^ children ifNil: [ children := #(  ) ]
]

{ #category : 'accessing' }
PulsarTestNodeModel >> children: aCollection [

	children := aCollection
]

{ #category : 'activation' }
PulsarTestNodeModel >> deselectAll [

	self toggleActivateBranch: false
]

{ #category : 'accessing' }
PulsarTestNodeModel >> entity [

	^ entity
]

{ #category : 'accessing' }
PulsarTestNodeModel >> entity: anObject [

	entity := anObject
]

{ #category : 'testing' }
PulsarTestNodeModel >> hasChildren [

	^ self children isNotEmpty
]

{ #category : 'accessing' }
PulsarTestNodeModel >> iconName [

	^ nil
]

{ #category : 'testing' }
PulsarTestNodeModel >> isActive [

	^ active ifNil: [ active := true ].

]

{ #category : 'testing' }
PulsarTestNodeModel >> matches: aPattern [

	^ self description asLowercase beginsWith: aPattern asLowercase
]

{ #category : 'accessing' }
PulsarTestNodeModel >> model [

	^ model
]

{ #category : 'accessing' }
PulsarTestNodeModel >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
PulsarTestNodeModel >> name [

	^ self entity name
]

{ #category : 'instance creation' }
PulsarTestNodeModel >> newActivationAnnouncement [

	^ self activationAnnouncementClass newValue: self
]

{ #category : 'instance creation' }
PulsarTestNodeModel >> newSelectionAnnouncement [

	^ self selectionAnnouncementClass newValue: self
]

{ #category : 'accessing' }
PulsarTestNodeModel >> parent [

	^ parent
]

{ #category : 'accessing' }
PulsarTestNodeModel >> parent: anObject [

	parent := anObject
]

{ #category : 'events' }
PulsarTestNodeModel >> resetStateChangedAction [

	stateChangedAction := nil
]

{ #category : 'activation' }
PulsarTestNodeModel >> selectAll [

	self toggleActivateBranch: true
]

{ #category : 'activation' }
PulsarTestNodeModel >> selectedMethodNodes [
	"Collect all active method nodes in this tree."

	| result |
	result := OrderedCollection new.
	self collectSelectedMethodsInto: result.
	^ result
]

{ #category : 'accessing' }
PulsarTestNodeModel >> selectionAnnouncementClass [

	^ PulsarModelSelected
]

{ #category : 'activation' }
PulsarTestNodeModel >> toggleActivateBranch: aBoolean [

	active := aBoolean.
	stateChangedAction ifNotNil: [ :block | block value: aBoolean ].
	self children do: [ :each | each toggleActivateBranch: aBoolean ].
	self updateParentActiveState
]

{ #category : 'activation' }
PulsarTestNodeModel >> toggleActiveInBranch [

	self toggleActivateBranch: self isActive not
]

{ #category : 'activation' }
PulsarTestNodeModel >> updateParentActiveState [

	parent ifNil: [ ^ self ].
	(self children allSatisfy: [ :each | each isActive ])
		ifTrue: [ parent active: true ]
		ifFalse: [
				(self children anySatisfy: [ :each | each isActive ])
					ifTrue: [ parent active: true "partial" ]
					ifFalse: [ parent active: false ] ].
	
	parent updateParentActiveState
]

{ #category : 'events' }
PulsarTestNodeModel >> whenStateChangedDo: aBlock [

	stateChangedAction := aBlock
]
