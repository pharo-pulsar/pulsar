Class {
	#name : 'PvClassModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'isNew'
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
	self flag: #TODO. "This is a hack, see how it should be for real?"
	self isNew ifTrue: [ ^ nil ].
	^ aVisitor visitClassModel: self
]

{ #category : 'accessing - actions' }
PvClassModel >> actionDecorators [
	"answer the actions associated with this class. E.g. test"
	
	^ self actions actionsFor: #decoration
]

{ #category : 'accessing - actions' }
PvClassModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: 'refactors') 
		copyWithContext: (PulsarRefactorClassContext on: aContextPresenter)
]

{ #category : 'updating' }
PvClassModel >> addProtocolNamed: aName [

	self entity addProtocol: (Protocol named: aName)
]

{ #category : 'updating' }
PvClassModel >> addSharedVariableNamed: aName [

	self entity addClassVarNamed: aName
]

{ #category : 'updating' }
PvClassModel >> addVariableNamed: aName type: aClass [

	self entity addSlot: (aClass named: aName asSymbol)
]

{ #category : 'accessing' }
PvClassModel >> allTestMethods [

	^ self entity allTestSelectors
		collect: [ :each | 
			PvMethodModel 
				newEnvironment: self environmentModel
				entity: self entity >> each ]
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

{ #category : 'converting' }
PvClassModel >> asPackageModel [
	
	^ PvPackageModel 
		newEnvironment: self environmentModel 
		parent: nil
		entity: self entity package
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

{ #category : 'accessing' }
PvClassModel >> comment [

	^ self entity comment
]

{ #category : 'accessing' }
PvClassModel >> commentOrTemplate [

	^ self comment ifEmpty: [ self commentTemplate ]
]

{ #category : 'accessing' }
PvClassModel >> commentTemplate [

	^ self entity classCommentBlank
]

{ #category : 'private - definitions' }
PvClassModel >> defineDecorationActionsOn: aBuilder [
	"action decorations for this class. 
	 this group should define all actions the method class can execute *everywhere* it is 
	 found (editors, class lists...)."
	<dockActions>
	
	aBuilder addGroup: #decoration with: [ :group | group
		name: 'Decorations';
		beDisplayedAsGroup.
		
		self isTestCase ifTrue: [
			group addActionWith: [ :action | action 
				name: 'Run Test';
				description: ('Execute test of {1} class' format: { self name });
				iconName: 'play';
				presenterClass: PulsarMethodActionRunTestPresenter;
				action: [ :aContext | self runTestAnnouncingTo: aContext notificationCenter ] ] ] 
	]
]

{ #category : 'private - definitions' }
PvClassModel >> defineRefactorActionsOn: aBuilder [
	<dockActions>
	
	"this actions cannot be used directly in this context (the model 
	 context), because execute them require interact with the UI"
	aBuilder addGroup: #refactors with: [ :group | group
		name: 'Refactors';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			name: ('Rename {1}' format: { self name });
			description: 'Rename class';
			action: [ :aContext | aContext doRenameClass: self ] ]; 
		addActionWith: [ :action | action
			name: ( 'Duplicate {1}' format: { self name });
			description: 'Rename class';
			action: [ :aContext | aContext doDuplicateClass: self ] ];
		addActionWith: [ :action | action
			name: 'Insert superclass';
			description: 'Insert a superclass';
			action: [ :aContext |  aContext doInsertSuperclass: self ] ];
		addActionWith: [ :action | action
			name: 'Insert subclass';
			description: 'Insert a subclass';
			action: [ :aContext |  aContext doInsertSubclass: self ] ];
		addActionWith: [ :action | action
			name: ( 'Remove {1}' format: { self name });
			description: 'Remove class';
			action: [ :aContext | aContext doRemoveClass: self ] ] ]
]

{ #category : 'accessing - ui' }
PvClassModel >> editorClass [
	
	^ PvClassEditorView
]

{ #category : 'accessing' }
PvClassModel >> fullName [

	^ self name
]

{ #category : 'private' }
PvClassModel >> hierarchyPresenterClass [

	^ PulsarClassHierarchyPresenter
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

{ #category : 'testing' }
PvClassModel >> isAbstract [

	^ self entity isAbstract
]

{ #category : 'testing' }
PvClassModel >> isClassModel [

	^ true
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

{ #category : 'testing' }
PvClassModel >> isTrait [

	^ self entity instanceSide isTrait
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

{ #category : 'printing' }
PvClassModel >> printOn: stream [

	super printOn: stream.
	stream << '(' << self name << ')'
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
PvClassModel >> selectionAnnouncementClass [

	^ PulsarClassModelSelected
]

{ #category : 'accessing' }
PvClassModel >> shortName [
	
	^ self name contractTo: self class shortSize
]

{ #category : 'accessing' }
PvClassModel >> traits [

	^ self entity traits collect: [ :each | 
		PvClassModel 
			newEnvironment: self environmentModel
			entity: each ]
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
