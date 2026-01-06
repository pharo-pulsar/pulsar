"
A base for all flags.
"
Class {
	#name : 'DockCritiquesModel',
	#superclass : 'Object',
	#traits : 'DockTEnvironmentModel + DockTModelVisitor',
	#classTraits : 'DockTEnvironmentModel classTrait + DockTModelVisitor classTrait',
	#instVars : [
		'critiques',
		'changeAction',
		'currentModel'
	],
	#category : 'Dock-Tool-CritiquesConsole',
	#package : 'Dock-Tool-CritiquesConsole'
}

{ #category : 'accessing' }
DockCritiquesModel class >> defaultScopeClass [

	^ self subclasses detect: [ :each | each isDefault ]
]

{ #category : 'testing' }
DockCritiquesModel class >> isDefault [

	^ false
]

{ #category : 'private' }
DockCritiquesModel >> calculateEnvironment [

	self subclassResponsibility
]

{ #category : 'private' }
DockCritiquesModel >> collectCritiques [
	| rules checker |
	
	self currentModel ifNil: [ ^ #() ].

	rules := self rules.	
	checker := ReSmalllintChecker new.
	checker classRules: rules.
	checker checkClass: self currentModel entity.
	^ checker critiques sorted: [ :each | each rule ruleName ] ascending
]

{ #category : 'accessing' }
DockCritiquesModel >> critiques [

	^ critiques ifNil: [ critiques := self collectCritiques ]
]

{ #category : 'private' }
DockCritiquesModel >> currentModel [

	^ currentModel
]

{ #category : 'testing' }
DockCritiquesModel >> isScope: aSymbol [

	^ false
]

{ #category : 'instance creation' }
DockCritiquesModel >> newActivationAnnouncementFor: aCritic [

	"this is different if this is a class ot a method"
	self subclassResponsibility
	"| announcement |

	announcement := DockModelActivated newValue: (PvMethodModel 
		newEnvironment: self environmentModel 
		entity: aCritic locationMethod).
	
	announcement selection: aFlag selection.
	
	^ announcement"
]

{ #category : 'private' }
DockCritiquesModel >> reset [

	critiques := nil
]

{ #category : 'private' }
DockCritiquesModel >> rules [

	self flag: #TODO. "This could be optimised to not being calculated each time" 
	^ ReRuleManager visibleRuleClasses collect: [ :aClass | aClass new ]
]

{ #category : 'accessing' }
DockCritiquesModel >> title [

	^ 'Critiques'
]

{ #category : 'updating' }
DockCritiquesModel >> updateWith: aModel [
	| updatingModel |

	updatingModel := aModel accept: self.
	
	currentModel = updatingModel ifTrue: [ ^ false ].
	currentModel := updatingModel.
	self reset.
	
	^ true
]

{ #category : 'visiting' }
DockCritiquesModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
DockCritiquesModel >> visitMethodModel: aModel [

	^ aModel
]
