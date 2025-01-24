Class {
	#name : 'PvMethodModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'decorators',
		'protocol',
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

{ #category : 'accessing' }
PvMethodModel >> actionDecorators [
	"answer the actions associated with this method. E.g. versions, test"
	
	^ actionDecorators ifNil: [ actionDecorators := self collectActionDecorators ]
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

{ #category : 'updating' }
PvMethodModel >> classifyMethodAs: aString [ 
	
	self entity protocol: aString.
	protocol := nil
]

{ #category : 'private' }
PvMethodModel >> collectActionDecorators [

	^ PvMethodActionDecorator allApplyingTo: self entity
]

{ #category : 'private' }
PvMethodModel >> collectDecorators [

	^ PvMethodDecorator allApplyingTo: self entity
]

{ #category : 'accessing - decorated' }
PvMethodModel >> colorName [

	^ self 
		decorated: [ :each | each colorName ] 
		ifNone: [ nil ]
]

{ #category : 'compiling' }
PvMethodModel >> compile: aString notifying: requestor [
	| selector |

	self sourceCode = aString ifTrue: [ ^ self ].

	[
		selector := self entity methodClass 
			compile: aString
			classified: self protocol
			notifying: requestor.
		self entity: self entity methodClass >> selector ]
	on: OCSemanticWarning 
	do: [ :w | 
		w resume: (w accept: PvMethodCompilationVisitor new) ]
]

{ #category : 'private' }
PvMethodModel >> decorated: aBlockOrSymbol ifNone: noneBlock [

	self decorators ifEmpty: [ ^ noneBlock value ].
	^ self decorators
		detect: [ :each | (aBlockOrSymbol value: each) notNil ]
		ifFound: [ :each | aBlockOrSymbol value: each ]
		ifNone: noneBlock
]

{ #category : 'accessing - decorated' }
PvMethodModel >> decoratedIconName [

	^ self 
		decorated: [ :each | each iconName ] 
		ifNone: [ #blank ]
]

{ #category : 'accessing' }
PvMethodModel >> decorators [

	^ decorators ifNil: [ decorators := self collectDecorators ]
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

	^ protocol isNotNil and: [ protocol isUnclassifiedProtocol not ] 
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
PvMethodModel >> isInstanceSide [
	
	^ self entity methodClass isInstanceSide
]

{ #category : 'accessing - navigating' }
PvMethodModel >> isLargeHierarchy [

	^ { Object. ProtoObject } includes: self entity methodClass
]

{ #category : 'testing' }
PvMethodModel >> isOutlineClassEntity [

	^ true
]

{ #category : 'testing' }
PvMethodModel >> isTestMethod [
	
	^ self entity isTestMethod
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

	^ self entity selector
]

{ #category : 'accessing' }
PvMethodModel >> protocol [

	^ protocol ifNil: [ protocol := self entity protocol ]
]

{ #category : 'accessing' }
PvMethodModel >> protocol: aString [

	protocol := aString
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

{ #category : 'updating' }
PvMethodModel >> removeMethod [

	self entity removeFromSystem
]

{ #category : 'updating' }
PvMethodModel >> runTest [
	| result |

	result := self methodClass debug: self entity selector.
	self entity
		propertyAt: #lastTestExecutionResult 
		put: result.

	^ result
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
 	| newMethod newSelector selectedClass |
	
 	selectedClass := self entity methodClass.

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
	"update protocol"
	protocol := entity protocol.

 	^ true
]

{ #category : 'accessing' }
PvMethodModel >> windowIconName [

	^ 'method'
]

{ #category : 'accessing' }
PvMethodModel >> windowTitle [

	^ self shortName
]
