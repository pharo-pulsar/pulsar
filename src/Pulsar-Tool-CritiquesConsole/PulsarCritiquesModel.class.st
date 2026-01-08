"
A base for all flags.
"
Class {
	#name : 'PulsarCritiquesModel',
	#superclass : 'Object',
	#traits : 'PulsarTEnvironmentModel + PulsarTModelVisitor',
	#classTraits : 'PulsarTEnvironmentModel classTrait + PulsarTModelVisitor classTrait',
	#instVars : [
		'critiques',
		'changeAction',
		'currentModel'
	],
	#category : 'Pulsar-Tool-CritiquesConsole',
	#package : 'Pulsar-Tool-CritiquesConsole'
}

{ #category : 'accessing' }
PulsarCritiquesModel class >> defaultScopeClass [

	^ self subclasses detect: [ :each | each isDefault ]
]

{ #category : 'testing' }
PulsarCritiquesModel class >> isDefault [

	^ false
]

{ #category : 'instance creation' }
PulsarCritiquesModel class >> on: aModel [

	^ self newEnvironment: aModel
]

{ #category : 'private' }
PulsarCritiquesModel >> calculateEnvironment [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarCritiquesModel >> collectCritiques [
	| rules checker |
	
	self currentModel ifNil: [ ^ #() ].

	rules := self rules.	
	checker := ReSmalllintChecker new.
	
	self currentModel isMethodModel
		ifTrue: [
			checker
				getCritiquesAbout: self currentModel entity
				by: (rules select: [ :r | r class checksMethod ]) ]
		ifFalse: [			
			checker classRules: rules.
			checker checkClass: self currentModel entity ].
			
	^ checker critiques sorted: [ :each | each rule ruleName ] ascending
]

{ #category : 'accessing' }
PulsarCritiquesModel >> critiques [

	^ critiques ifNil: [ critiques := self collectCritiques ]
]

{ #category : 'private' }
PulsarCritiquesModel >> currentModel [

	^ currentModel
]

{ #category : 'testing' }
PulsarCritiquesModel >> isScope: aSymbol [

	^ false
]

{ #category : 'instance creation' }
PulsarCritiquesModel >> newActivationAnnouncementFor: aCritic [

	"this is different if this is a class ot a method"
	self subclassResponsibility
	"| announcement |

	announcement := PulsarModelActivated newValue: (PvMethodModel 
		newEnvironment: self environmentModel 
		entity: aCritic locationMethod).
	
	announcement selection: aFlag selection.
	
	^ announcement"
]

{ #category : 'private' }
PulsarCritiquesModel >> reset [

	critiques := nil
]

{ #category : 'private' }
PulsarCritiquesModel >> rules [

	self flag: #LATER. "This could be optimised to not being calculated each time" 
	^ ReRuleManager visibleRuleClasses collect: [ :aClass | aClass new ]
]

{ #category : 'accessing' }
PulsarCritiquesModel >> title [

	^ self currentModel 
		ifNotNil: [ 'Critiques of {1}' format: { self currentModel fullName } ]
		ifNil: [ 'Critiques' ] 
]

{ #category : 'updating' }
PulsarCritiquesModel >> updateWith: aModel [
	| updatingModel |

	updatingModel := aModel accept: self.
	
	currentModel = updatingModel ifTrue: [ ^ false ].
	currentModel := updatingModel.
	self reset.
	
	^ true
]

{ #category : 'visiting' }
PulsarCritiquesModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
PulsarCritiquesModel >> visitMethodModel: aModel [

	^ aModel
]
