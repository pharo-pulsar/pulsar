Class {
	#name : #PvClassModel,
	#superclass : #PvEntityModel,
	#instVars : [
		'isNew'
	],
	#category : #'Perspective-Class-Model'
}

{ #category : #converting }
PvClassModel >> asClassModel [

	^ self
]

{ #category : #converting }
PvClassModel >> asOutlineClassModel [

	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : #accessing }
PvClassModel >> beForNewClass [

	isNew := true
]

{ #category : #accessing }
PvClassModel >> classDefinitionString [
	
	self flag: #TODO. "I do not like to use an if here... but for now is easier 
	than pollute the model"
	^ self entity isClassOrTrait 
		ifTrue: [ (PvFluidClassDefinitionPrinter for: self entity) definitionString ]
		ifFalse: [ self entity classDefinitionString ]	
]

{ #category : #accessing }
PvClassModel >> classDepth [
	
	^ self entity classDepth
]

{ #category : #accessing }
PvClassModel >> comment [

	^ self entity comment
]

{ #category : #compiling }
PvClassModel >> compile: aString notifying: requestor [
	| resultClass |

 	[ 
		resultClass := self class compiler
			source: '(', aString, ') install';
			context: requestor doItContext;
			receiver: requestor doItReceiver;
			requestor: requestor;
			evaluate.
		resultClass isBehavior 
			ifTrue: [ self entity: resultClass ] ]
	on: OCUndeclaredVariableWarning
	do: [ :e | 
		"we are only interested in class definitions"
		e compilationContext noPattern ifFalse: [ e pass ] ]
]

{ #category : #'accessing - ui' }
PvClassModel >> editorClass [
	
	^ PvClassEditorView
]

{ #category : #accessing }
PvClassModel >> fullName [

	^ self name
]

{ #category : #'accessing - navigating' }
PvClassModel >> hierarchyTopModel [
	| node prevNode |

	prevNode := PvClassHierarchyNodeModel 
		newEnvironment: self environmentModel 
		entity: self entity.
	prevNode childrenNodeProvider: [ :anEntity | anEntity subclasses ].

	self entity allSuperclasses do: [ :each |
		node := PvClassHierarchyNodeModel
			newEnvironment: self environmentModel 
			entity: each.
		node child: prevNode.
		prevNode := node ].
	
	^ node
]

{ #category : #'accessing - ui' }
PvClassModel >> iconName [
	
	^ self entity systemIconName
]

{ #category : #testing }
PvClassModel >> includesClassModel [

	^ true
]

{ #category : #testing }
PvClassModel >> inheritsFrom: aClassModel [ 
	
	aClassModel ifNil: [ ^ false ].
	^ self entity instanceSide inheritsFrom: aClassModel entity instanceSide
]

{ #category : #initialization }
PvClassModel >> initialize [

	super initialize.
	isNew := false
]

{ #category : #'accessing - navigating' }
PvClassModel >> isLargeHierarchy [

	^ { Object. ProtoObject } includes: self entity
]

{ #category : #testing }
PvClassModel >> isOutlineClassEntity [

	^ self entity isClassOrTrait
]

{ #category : #accessing }
PvClassModel >> name [

	^ self entity name asString
]

{ #category : #accessing }
PvClassModel >> packageName [

	^ self entity package name
]

{ #category : #accessing }
PvClassModel >> shortName [
	
	^ self name contractTo: self class shortSize
]

{ #category : #accessing }
PvClassModel >> windowCommentIconName [

	^ self entity hasComment
		ifTrue: [ #comments ]
		ifFalse: [ #uncommentedClass ]
]
