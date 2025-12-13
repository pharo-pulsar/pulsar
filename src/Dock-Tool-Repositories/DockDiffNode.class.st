"
A node to traverse (and cherry pick) the diff tree.
"
Class {
	#name : 'DockDiffNode',
	#superclass : 'DockRepositoryBaseModel',
	#instVars : [
		'active',
		'children',
		'activeAction',
		'parent',
		'patch'
	],
	#category : 'Dock-Tool-Repositories',
	#package : 'Dock-Tool-Repositories'
}

{ #category : 'instance creation' }
DockDiffNode class >> on: aNode [

	^ self new 
		node: aNode;
		yourself
]

{ #category : 'accessing' }
DockDiffNode >> active: aBoolean [

	active := aBoolean.
	activeAction ifNotNil: [ activeAction cull: aBoolean ]
]

{ #category : 'accessing' }
DockDiffNode >> children [

	^ children ifNil: [ children := self collectChildren ]
]

{ #category : 'private' }
DockDiffNode >> collectChildren [

	^ self node children collect: [ :each | 
		(DockDiffNode newRepository: self repository entity: each)
			parent: self;
			yourself ]
]

{ #category : 'private' }
DockDiffNode >> createPatch [
	| operation from to |
	
	operation := self node value.
	^ SpPatchModel 
		newFrom: operation rightContents 
		to: operation leftContents
]

{ #category : 'accessing' }
DockDiffNode >> description [
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
DockDiffNode >> hasChanges [
	| operation |

	operation := self node value.
	^ operation rightContents ~= operation leftContents
]

{ #category : 'testing' }
DockDiffNode >> hasChildren [

	^ self children isEmptyOrNil not
]

{ #category : 'testing' }
DockDiffNode >> hasParent [

	^ parent isNotNil
]

{ #category : 'accessing' }
DockDiffNode >> iconName [

	^ self node value iconName
]

{ #category : 'initialization' }
DockDiffNode >> initialize [

	super initialize.
	self active: true
]

{ #category : 'testing' }
DockDiffNode >> isActive [

	^ active
]

{ #category : 'testing' }
DockDiffNode >> isDirectory [

	^ false
]

{ #category : 'testing' }
DockDiffNode >> isRoot [

	^ self node value definition isDirectoryDefinition
]

{ #category : 'accessing' }
DockDiffNode >> node [

	^ self entity
]

{ #category : 'accessing' }
DockDiffNode >> parent [

	^ parent
]

{ #category : 'accessing' }
DockDiffNode >> parent: aNode [

	parent := aNode
]

{ #category : 'accessing' }
DockDiffNode >> patch [
	"answer a patch for this model"
	
	^ patch ifNil: [ patch := self createPatch ]
]

{ #category : 'accessing' }
DockDiffNode >> patchDeletions [

	^ (self patch patch elements select: #isDelete) size
]

{ #category : 'accessing' }
DockDiffNode >> patchInsertions [

	^ (self patch patch elements select: #isInsert) size
]

{ #category : 'events' }
DockDiffNode >> resetStateChangedAction [

	activeAction := nil
]

{ #category : 'accessing' }
DockDiffNode >> summary [ 

	^ '+{1}/-{2}: {3}' format: { 
		self patchInsertions. 
		self patchDeletions.
		self description }
]

{ #category : 'accessing' }
DockDiffNode >> toggleActivateBranch: aBoolean [

	self active: aBoolean.
	self withAllChildrenDo: [ :eachNode | 
		eachNode active: aBoolean ]
]

{ #category : 'accessing' }
DockDiffNode >> toggleActiveInBranch [

	self toggleActivateBranch: self isActive not
]

{ #category : 'events' }
DockDiffNode >> whenStateChangedDo: aBlock [

	activeAction := aBlock
]

{ #category : 'private' }
DockDiffNode >> withAllChildrenDo: aBlock [
 
 	aBlock value: self.
 	self children do: [ :each | 
 		each withAllChildrenDo: aBlock ] 
]
