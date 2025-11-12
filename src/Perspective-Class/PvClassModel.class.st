Class {
	#name : 'PvClassModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'isNew',
		'actionDecorators'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvClassModel class >> newEnvironment: anEnvirontmentModel beNewClassWithParent: aParentModel [

	^ (self 
		newEnvironment: anEnvirontmentModel 
		entity: (PvNewClassTemplate new 
			parentModel: aParentModel;
			yourself))
		beForNewClass
]

{ #category : 'instance creation' }
PvClassModel class >> newEnvironment: anEnvirontmentModel beNewTraitWithParent: aParentModel [

	^ (self 
		newEnvironment: anEnvirontmentModel 
		entity: (PvNewTraitTemplate new 
			parentModel: aParentModel;
			yourself))
		beForNewClass
]

{ #category : 'visiting' }
PvClassModel >> accept: aVisitor [

	^ aVisitor visitClassModel: aVisitor
]

{ #category : 'accessing' }
PvClassModel >> actionDecorators [
	"answer the actions associated with this class. E.g. test"
	
	^ actionDecorators ifNil: [ actionDecorators := self collectActionDecorators ]
]

{ #category : 'updating' }
PvClassModel >> addProtocolNamed: aName [

	self entity addProtocol: (Protocol named: aName)
]

{ #category : 'updating' }
PvClassModel >> addVariableNamed: aName type: aClass [

	self entity addSlot: (aClass named: aName asSymbol)
]

{ #category : 'converting' }
PvClassModel >> asClassModel [

	^ self
]

{ #category : 'converting' }
PvClassModel >> asOutlineClassModel [

	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'accessing' }
PvClassModel >> beForNewClass [

	isNew := true
]

{ #category : 'accessing' }
PvClassModel >> classDefinitionString [
	
	self flag: #TODO. "I do not like to use an if here... but for now is easier 
	than pollute the model"
	^ self entity isClassOrTrait 
		ifTrue: [ (PvFluidClassDefinitionPrinter for: self entity) definitionString ]
		ifFalse: [ self entity classDefinitionString ]	
]

{ #category : 'accessing' }
PvClassModel >> classDepth [
	
	^ self entity classDepth
]

{ #category : 'accessing - parallel hierarchy' }
PvClassModel >> classSide [

	^ self entity classSide
]

{ #category : 'private' }
PvClassModel >> collectActionDecorators [

	^ PvClassActionDecorator allApplyingTo: self
]

{ #category : 'accessing' }
PvClassModel >> comment [

	^ self entity comment
]

{ #category : 'updating' }
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

{ #category : 'accessing - ui' }
PvClassModel >> editorClass [
	
	^ PvClassEditorView
]

{ #category : 'accessing' }
PvClassModel >> fullName [

	^ self name
]

{ #category : 'accessing - navigating' }
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

{ #category : 'accessing - ui' }
PvClassModel >> iconComposite [

	^ PvCompositeIcon new 
		name: self iconName;
		in: [ :this | 
			self entity isAbstract 
			ifTrue: [ this addAbstract ] ];
		yourself
]

{ #category : 'accessing - ui' }
PvClassModel >> iconName [
	
	^ self entity systemIconName
]

{ #category : 'testing' }
PvClassModel >> includesClassModel [

	^ true
]

{ #category : 'testing' }
PvClassModel >> includesSelectorInAnySide: aSelector [

	^ (self instanceSide includesSelector: aSelector)
		or: [ self classSide includesSelector: aSelector ]
]

{ #category : 'testing' }
PvClassModel >> inheritsFrom: aClassModel [ 
	
	aClassModel ifNil: [ ^ false ].
	^ self entity instanceSide inheritsFrom: aClassModel entity instanceSide
]

{ #category : 'initialization' }
PvClassModel >> initialize [

	super initialize.
	isNew := false
]

{ #category : 'accessing - parallel hierarchy' }
PvClassModel >> instanceSide [

	^ self entity instanceSide
]

{ #category : 'accessing - navigating' }
PvClassModel >> isLargeHierarchy [

	^ { Object. ProtoObject } includes: self entity
]

{ #category : 'testing' }
PvClassModel >> isNew [

	^ isNew
]

{ #category : 'testing' }
PvClassModel >> isOutlineClassEntity [

	^ self entity isClassOrTrait
]

{ #category : 'testing' }
PvClassModel >> isSameClass: aClass [

	^ self instanceSide = aClass instanceSide 
]

{ #category : 'testing' }
PvClassModel >> isTestCase [

	^ self entity isTestCase
]

{ #category : 'accessing' }
PvClassModel >> lastTestExecutionResult [

	^ TestResult fromTestCaseHistory: self entity
]

{ #category : 'accessing' }
PvClassModel >> name [

	^ self entity name asString
]

{ #category : 'accessing' }
PvClassModel >> packageName [

	^ self entity package name
]

{ #category : 'accessing' }
PvClassModel >> packageTagName [

	^ self entity packageTag name
]

{ #category : 'private' }
PvClassModel >> prepareForSnapshot [

	actionDecorators := nil
]

{ #category : 'accessing' }
PvClassModel >> resetActionDecorators [
	"do nothing, class do not have action decorators"
]

{ #category : 'actions' }
PvClassModel >> runTestAnnouncingTo: anAnnouncer [
	| testSuite |
	
	testSuite := self entity suite.
	"resend announcements"
	testSuite testSuiteAnnouncer 
		when: TestCaseAnnouncement
		send: #announce: 
		to: anAnnouncer.
	[ testSuite run ]
	ensure: [ 
		testSuite testSuiteAnnouncer unsubscribe: anAnnouncer ]
]

{ #category : 'updating' }
PvClassModel >> saveComment: aString [

	self entity comment: aString
]

{ #category : 'accessing' }
PvClassModel >> shortName [
	
	^ self name contractTo: self class shortSize
]

{ #category : 'updating' }
PvClassModel >> updateWith: aString notifying: anInteractionModel [
	| fluidDefinition |
	
	self flag: #TODO. "This is how calypso is doing it... but shouldn't we use 
	the parse, etc. mechanism?"
	[
		fluidDefinition := (self environmentModel compilerForClass: self entity)
			source: aString;
			requestor: anInteractionModel;
			failBlock: [ ^ false ];
			logged: true;
			evaluate ]
	on: Error do: [ :e | 
		self halt.
		^ false ].
	
	self entity: fluidDefinition fluidInstall.
	"no matter what we had before, this is no longer new"
	isNew := false.

	^ true
]

{ #category : 'accessing' }
PvClassModel >> windowCommentIconName [

	^ self entity hasComment
		ifTrue: [ #comments ]
		ifFalse: [ #uncommentedClass ]
]

{ #category : 'accessing - ui' }
PvClassModel >> windowIconComposite [

	^ PvCompositeIcon new 
		name: self iconName;
		in: [ :this | 
			self entity isAbstract 
			ifTrue: [ this addAbstract ] ];
		yourself
]
