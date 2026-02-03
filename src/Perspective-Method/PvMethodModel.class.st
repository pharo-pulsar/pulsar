Class {
	#name : 'PvMethodModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'decorators',
		'actionDecorators'
	],
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvMethodModel class >> newEnvironment: anEnvironmentModel beNewClassMethodWithParent: aClassModel [

	^ self new 
		entity: (PvNewMethodTemplate 
			newEnvironmentModel: anEnvironmentModel 
			parent: aClassModel)
			beForClassSide;
		yourself
]

{ #category : 'instance creation' }
PvMethodModel class >> newEnvironment: anEnvironmentModel beNewMethodWithParent: aClassModel [

	^ self new 
		entity: (PvNewMethodTemplate 
			newEnvironmentModel: anEnvironmentModel 
			parent: aClassModel);
		yourself
]

{ #category : 'instance creation' }
PvMethodModel class >> newMethod: aMethod [ 

	^ self new 
		method: aMethod;
		yourself
]

{ #category : 'visiting' }
PvMethodModel >> accept: aVisitor [

	^ aVisitor visitMethodModel: self
]

{ #category : 'accessing - actions' }
PvMethodModel >> actionDecorators [
	"answer the actions associated with this method. E.g. versions, test"
	
	^ self actions actionsFor: #decoration
]

{ #category : 'accessing - actions' }
PvMethodModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: 'refactors') 
		copyWithContext: (PulsarRefactorMethodContext on: aContextPresenter)
]

{ #category : 'converting' }
PvMethodModel >> asClassModel [
	
	^ PvClassModel 
		newEnvironment: self environmentModel 
		entity: self methodClass
]

{ #category : 'converting' }
PvMethodModel >> asOutlineClassModel [
	
	^ PvOutlineClassModel 
		newEnvironment: self environmentModel 
		entity: self methodClass
]

{ #category : 'converting' }
PvMethodModel >> asPackageModel [
	
	^ PvPackageModel 
		newEnvironment: self environmentModel 
		parent: nil
		entity: self methodClass package
]

{ #category : 'updating' }
PvMethodModel >> classifyMethodAs: aString [ 
	
	self entity protocol: aString
]

{ #category : 'private' }
PvMethodModel >> collectActionDecorators [

	^ PvMethodActionDecorator allApplyingTo: self
]

{ #category : 'private' }
PvMethodModel >> collectDecorators [

	^ PvMethodDecorator allApplyingTo: self
]

{ #category : 'private' }
PvMethodModel >> decorated: aBlockOrSymbol ifNone: noneBlock [

	self decorators ifEmpty: [ ^ noneBlock value ].
	^ self decorators
		detect: [ :each | (aBlockOrSymbol value: each) notNil ]
		ifFound: [ :each | aBlockOrSymbol value: each ]
		ifNone: noneBlock
]

{ #category : 'private' }
PvMethodModel >> decorationAs: aDecorationClass [

	^ self decorators
		detect: [ :each | each class = aDecorationClass ]
		ifNone: [ ^ nil ]
]

{ #category : 'accessing' }
PvMethodModel >> decorators [

	^ decorators ifNil: [ decorators := self collectDecorators ]
]

{ #category : 'private - definitions' }
PvMethodModel >> defineDecorationActionsOn: aBuilder [
	"action decorations for this method. 
	 this group should define all actions the method model can execute *everywhere* it is 
	 found (editors, methods lists...)."
	<dockActions>
	
	aBuilder addGroup: #decoration with: [ :group | 
		group 
			name: 'Decoration';
			beDisplayedAsGroup.
			
		group addActionWith: [ :action | action 
			name: 'Versions';
			description: ('Browse versions of [self name]');
			iconName: 'versions';
			action: [ :aContext | aContext doBrowseVersionsCommand: action ] ].
			
		self isExampleMethod ifTrue: [
			group addActionWith: [ :action | action 
				name: 'Run Sample';
				description: 'Execute [self name] and take a sample instance';
				iconName: 'play'	;
				action: [ :aContext | aContext doRunSampleInstanceCommand: action ] ] ].
				
		self isScriptMethod ifTrue: [
			group addActionWith: [ :action | action 
				name: 'Run Script';
				description: 'Execute [self name]';
				iconName: 'play';
				action: [ :aContext | aContext doRunScriptCommand: action ] ] ].
				
		self isTestMethod ifTrue: [
			group addActionWith: [ :action | action 
				name: 'Run Test';
				description: 'Execute test of current method/class';
				iconName: 'play';
				presenterClass: PulsarMethodActionRunTestPresenter;
				action: [ :aContext | aContext doRunTestCommand: action ] ] ].
	]
]

{ #category : 'private - definitions' }
PvMethodModel >> defineRefactorActionsOn: aBuilder [
	<dockActions>

	"this actions cannot be used directly in this context (the model 
	 context), because execute them require interact with the UI"
	aBuilder addGroup: #refactors with: [ :group | group 
		name: 'Refactors';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			name: ('Rename {1}' format: { self name });
			description: 'Rename method';
			action: [ :aContext | aContext doRenameMethod: self ] ];
		addActionWith: [ :action | action
			name: ('Pull up {1}' format: { self name });
			description: 'Pull up method';
			action: [ :aContext | aContext doPullUpMethod: self ] ];
		addActionWith: [ :action | action
			name: ('Push down {1}' format: { self name });
			description: 'Push down method';
			action: [ :aContext | aContext doPushDownMethod: self ] ] ]
]

{ #category : 'accessing - editor' }
PvMethodModel >> editorClass [

	^ PvMethodEditorView
]

{ #category : 'accessing' }
PvMethodModel >> fullName [

	^ String streamContents: [ :stream | 
		stream 
			<< self methodClassName
			<< '>>'
			<< self name ]
]

{ #category : 'testing' }
PvMethodModel >> hasDefinedProtocol [

	^ self protocol isNotNil and: [ self protocol isUnclassifiedProtocol not ] 
]

{ #category : 'accessing - navigating' }
PvMethodModel >> hierarchyTopModel [
	| systemNavigation nodes |
	
	systemNavigation := PvSystemNavigation new.
	self isLargeHierarchy ifFalse: [
			| environment |
			environment := SystemEnvironment new.
			self entity origin allSuperclasses 
				do: [ :each | environment at: each instanceSide name put: each ].
			self entity origin withAllSubclasses 
				do: [ :each | environment at: each instanceSide name put: each ].
			systemNavigation environment: environment ].
	
	nodes := (systemNavigation allImplementorsOf: self entity selector)
		collect: [ :each | 
			PvMethodHierarchyNodeModel 
				newEnvironment: self environmentModel 
				entity: each ].
	
	nodes do: [ :each | each findParentFrom: nodes ].

	^ nodes 
		detect: [ :each | each parent isNil ]
		ifNone: [ 
			PvMethodHierarchyNodeModel 
				newEnvironment: self environmentModel 
				entity: self entity ]
]

{ #category : 'accessing' }
PvMethodModel >> iconName [

	^ #method
]

{ #category : 'testing' }
PvMethodModel >> includesClassModel [

	^ true
]

{ #category : 'testing' }
PvMethodModel >> isExampleMethod [

	^ ((self entity pragmas collect: [ :each | each selector ]) includesAny: #(sampleInstance example))
		or: [ self entity isClassSide and: [ self selector beginsWith: 'example' ] ]
]

{ #category : 'testing' }
PvMethodModel >> isInstanceSide [
	
	^ self entity methodClass isInstanceSide
]

{ #category : 'accessing - navigating' }
PvMethodModel >> isLargeHierarchy [

	^ { Object. ProtoObject } includes: self entity methodClass
]

{ #category : 'testing' }
PvMethodModel >> isMethodModel [

	^ true
]

{ #category : 'testing' }
PvMethodModel >> isNew [

	^ false
]

{ #category : 'testing' }
PvMethodModel >> isOutlineClassEntity [

	^ true
]

{ #category : 'testing' }
PvMethodModel >> isSameAs: aMethodModel [

	^ self methodClass = aMethodModel methodClass 
		and: [ self selector = aMethodModel selector ]
]

{ #category : 'testing' }
PvMethodModel >> isScriptMethod [

	^ (self entity pragmas collect: [ :each | each selector ]) 
		includes: #script
]

{ #category : 'testing' }
PvMethodModel >> isTestError [
	"this assumes the method is a test method"

	^ self methodClass methodRaisedError: self selector
]

{ #category : 'testing' }
PvMethodModel >> isTestFailure [
	"this assumes the method is a test method"

	^ self methodClass methodFailed: self selector
]

{ #category : 'testing' }
PvMethodModel >> isTestMethod [
	
	^ self entity isTestMethod
]

{ #category : 'testing' }
PvMethodModel >> isTestPassed [
	"this assumes the method is a test method"

	^ self methodClass methodPassed: self selector
]

{ #category : 'testing' }
PvMethodModel >> isUsingAnyVariable: aCollection [

	^ aCollection anySatisfy: [ :each |
		self isUsingVariable: each ]
]

{ #category : 'testing' }
PvMethodModel >> isUsingVariable: aVariableModel [

	^ aVariableModel isIncludedIn: self
]

{ #category : 'updating' }
PvMethodModel >> lastTestExecutionResult [
	| lastClassResult result testCase | 

	lastClassResult := TestResult fromTestCaseHistory: self methodClass.
 
	result := TestResult new.
	testCase := lastClassResult tests 
		detect: [ :each | each selector = self entity selector ]
		ifNone: [ ^ nil ].

	(lastClassResult isError: testCase) ifTrue: [ result addError: testCase ].
	(lastClassResult isFailure: testCase) ifTrue: [ result addFailure: testCase ].
	(lastClassResult isPassed: testCase) ifTrue: [ result addPass: testCase ].
	
	^ result tests
		ifNotEmpty: [ result ]			
		ifEmpty: [ nil ]
]

{ #category : 'accessing' }
PvMethodModel >> methodClass [

	^ self entity methodClass instanceSide
]

{ #category : 'accessing' }
PvMethodModel >> methodClassName [

	^ self entity methodClass name
]

{ #category : 'accessing' }
PvMethodModel >> name [

	^ self selector
]

{ #category : 'instance creation' }
PvMethodModel >> newVersionsModel [

	^ PulsarVersionsModel 
		newEnvironment: self environmentModel 
		entity: self entity
]

{ #category : 'private' }
PvMethodModel >> prepareForSnapshot [

	decorators := nil.
	actionDecorators := nil
]

{ #category : 'printing' }
PvMethodModel >> printOn: stream [ 

	super printOn: stream.
	stream << '(' << self fullName << ')'
]

{ #category : 'accessing' }
PvMethodModel >> protocol [

	^ self entity protocol
]

{ #category : 'accessing' }
PvMethodModel >> protocolModel [
	
	^ PvProtocolModel 
		newEnvironment: self environmentModel 
		entity: self entity protocol
]

{ #category : 'accessing' }
PvMethodModel >> protocolName [
	
	^ self protocol 
		ifNotNil: [ :aProtocol | aProtocol name ]
		ifNil: [ 'no protocol' ]
]

{ #category : 'accessing - ui' }
PvMethodModel >> pulsarEditorClass [

	^ PulsarMethodEditor
]

{ #category : 'updating' }
PvMethodModel >> removeMethod [

	self entity removeFromSystem
]

{ #category : 'accessing' }
PvMethodModel >> resetActionDecorators [
	
	actionDecorators := nil
]

{ #category : 'actions' }
PvMethodModel >> runScript [
	| result |
	
	result := self entity valueWithReceiver: self entity methodClass instanceSide.
	"avoid result if it was ^self" 
	(result isBehavior and: [ result = self entity methodClass instanceSide ]) 
		ifTrue: [ ^ nil ].
	
	^ result
]

{ #category : 'actions' }
PvMethodModel >> runTestAnnouncingTo: anAnnouncer [
	| testSuite testCase |
	
	testCase := self methodClass selector: self entity selector.
	testSuite := TestSuite new
		addTest: testCase;
		yourself.
	"resend announcements"
	testSuite testSuiteAnnouncer 
		when: TestCaseAnnouncement
		send: #announce: 
		to: anAnnouncer.
	[ testSuite debug ]
	ensure: [ 
		testSuite testSuiteAnnouncer unsubscribe: anAnnouncer ]
]

{ #category : 'accessing' }
PvMethodModel >> selectionAnnouncementClass [

	^ PulsarMethodModelSelected
]

{ #category : 'accessing' }
PvMethodModel >> selector [

	^ self entity selector
]

{ #category : 'accessing' }
PvMethodModel >> shortName [

	^ self name contractTo: self class shortSize
]

{ #category : 'accessing' }
PvMethodModel >> sourceCode [
	
	^ self entity sourceCode
]

{ #category : 'accessing' }
PvMethodModel >> spotterTitle [

	^ String streamContents: [ :stream |
		stream << self windowTitle << ' (' << self methodClass name << ')' ]
]

{ #category : 'updating' }
PvMethodModel >> updateWith: aString notifying: anInteractionModel [
 	| newMethod newSelector selectedClass protocol |
	
 	selectedClass := self entity methodClass.
 	protocol := self entity protocol.

	[
		newMethod := selectedClass compiler 
			source: aString;
			requestor: anInteractionModel;
			permitUndeclared: true;
			install ]
	on: OCUndeclaredVariableWarning 
	do: [ :w | w resume ].
	
 	newMethod ifNil: [ ^ false ].
 	newSelector := newMethod selector.

	"do not try to classify if already classified"
	newMethod protocol isUnclassifiedProtocol ifTrue: [
		self hasDefinedProtocol
			ifTrue: [ newMethod protocol: protocol ]
			ifFalse: [ MethodClassifier classify: newMethod ] ].

	"update entity"
	entity := newMethod.

 	^ true
]

{ #category : 'accessing' }
PvMethodModel >> windowTitle [

	^ self shortName
]
