"
A node to traverse (and cherry pick) the diff tree.
"
Class {
	#name : 'PulsarDiffNode',
	#superclass : 'PulsarRepositoryBaseModel',
	#instVars : [
		'active',
		'children',
		'activeAction',
		'parent',
		'patch'
	],
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarDiffNode class >> on: aNode [

	^ self new 
		node: aNode;
		yourself
]

{ #category : 'accessing' }
PulsarDiffNode >> active: aBoolean [

	active := aBoolean.
	activeAction ifNotNil: [ activeAction cull: aBoolean ]
]

{ #category : 'accessing' }
PulsarDiffNode >> allChildren [

	^ Array streamContents: [ :stream | 
		self withAllChildrenDo: [ :aNode | 
			stream nextPut: aNode ] ]
]

{ #category : 'accessing' }
PulsarDiffNode >> children [

	^ children ifNil: [ children := self collectChildren ]
]

{ #category : 'accessing' }
PulsarDiffNode >> classNamed: aName [

	self flag: #FIXME. "Demeters law"
	^ self repository environmentModel classNamed: aName
]

{ #category : 'private' }
PulsarDiffNode >> collectChildren [

	^ self node children collect: [ :each | 
		(PulsarDiffNode newRepository: self repository entity: each)
			parent: self;
			yourself ]
]

{ #category : 'accessing' }
PulsarDiffNode >> countChildren [
	| count |

	count := 0.
	self withAllChildrenDo: [ :aNode | 
		count := count + 1 ].
	^ count
]

{ #category : 'private' }
PulsarDiffNode >> createPatch [
	| operation from to patch |
	
	operation := self node value.
	patch := SpPatchModel
		newFrom: operation rightContents 
		to: operation leftContents.
	operation leftDefinition isMethodDefinition
		ifTrue: [ patch originBehavior: (self classNamed: operation leftDefinition className) ].
		
	^ patch
]

{ #category : 'accessing' }
PulsarDiffNode >> description [
	| operation |
	
	operation := self node value.
	
	^ operation definition isMethodDefinition 
		ifTrue: [ 
			'{1} >> {2}' format: { 
				operation definition className. 
				operation definition name } ]
		ifFalse: [ 
			operation definition name ]
]

{ #category : 'testing' }
PulsarDiffNode >> hasChanges [
	| operation |

	operation := self node value.
	^ operation rightContents ~= operation leftContents
]

{ #category : 'testing' }
PulsarDiffNode >> hasChildren [

	^ self children isEmptyOrNil not
]

{ #category : 'testing' }
PulsarDiffNode >> hasParent [

	^ parent isNotNil
]

{ #category : 'accessing' }
PulsarDiffNode >> iconName [

	^ self node value iconName
]

{ #category : 'initialization' }
PulsarDiffNode >> initialize [

	super initialize.
	self active: true
]

{ #category : 'testing' }
PulsarDiffNode >> isActive [

	^ active
]

{ #category : 'accessing' }
PulsarDiffNode >> isBigChange [

	^ self countChildren > 750
]

{ #category : 'testing' }
PulsarDiffNode >> isDirectory [

	^ false
]

{ #category : 'testing' }
PulsarDiffNode >> isRoot [

	^ self node value definition isDirectoryDefinition
]

{ #category : 'accessing' }
PulsarDiffNode >> name [

	^ self description
]

{ #category : 'accessing' }
PulsarDiffNode >> node [

	^ self entity
]

{ #category : 'accessing' }
PulsarDiffNode >> parent [

	^ parent
]

{ #category : 'accessing' }
PulsarDiffNode >> parent: aNode [

	parent := aNode
]

{ #category : 'accessing' }
PulsarDiffNode >> patch [
	"answer a patch for this model"
	
	^ patch ifNil: [ patch := self createPatch ]
]

{ #category : 'accessing' }
PulsarDiffNode >> patchDeletions [

	^ (self patch patch elements select: #isDelete) size
]

{ #category : 'accessing' }
PulsarDiffNode >> patchInsertions [

	^ (self patch patch elements select: #isInsert) size
]

{ #category : 'events' }
PulsarDiffNode >> resetStateChangedAction [

	activeAction := nil
]

{ #category : 'accessing' }
PulsarDiffNode >> summary [ 

	^ '<span foreground="green">+{1}</span>/<span foreground="red">-{2}</span>: {3}' format: { 
		self patchInsertions. 
		self patchDeletions.
		self description }
]

{ #category : 'accessing' }
PulsarDiffNode >> toggleActivateBranch: aBoolean [

	self active: aBoolean.
	self withAllChildrenDo: [ :eachNode | 
		eachNode active: aBoolean ]
]

{ #category : 'accessing' }
PulsarDiffNode >> toggleActiveInBranch [

	self toggleActivateBranch: self isActive not
]

{ #category : 'events' }
PulsarDiffNode >> whenStateChangedDo: aBlock [

	activeAction := aBlock
]

{ #category : 'private' }
PulsarDiffNode >> withAllChildrenDo: aBlock [
 
 	aBlock value: self.
 	self children do: [ :each | 
 		each withAllChildrenDo: aBlock ] 
]
