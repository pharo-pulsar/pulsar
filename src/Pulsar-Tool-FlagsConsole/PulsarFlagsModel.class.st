"
A base for all flags.
"
Class {
	#name : 'PulsarFlagsModel',
	#superclass : 'Object',
	#traits : 'PulsarTEnvironmentModel + PulsarTModelVisitor',
	#classTraits : 'PulsarTEnvironmentModel classTrait + PulsarTModelVisitor classTrait',
	#instVars : [
		'flags',
		'changeAction',
		'currentModel'
	],
	#category : 'Pulsar-Tool-FlagsConsole',
	#package : 'Pulsar-Tool-FlagsConsole'
}

{ #category : 'accessing' }
PulsarFlagsModel class >> defaultScopeClass [

	^ self subclasses detect: [ :each | each isDefault ]
]

{ #category : 'testing' }
PulsarFlagsModel class >> isDefault [

	^ false
]

{ #category : 'instance creation' }
PulsarFlagsModel class >> on: aModel [

	^ self defaultScopeClass newEnvironment: aModel
]

{ #category : 'private' }
PulsarFlagsModel >> calculateEnvironment [

	self subclassResponsibility
]

{ #category : 'private' }
PulsarFlagsModel >> collectFlags [
	| nodes |

	nodes := (self newSystemNavigation allSendersOf: #flag:)
		flatCollect: [ :sender | 
			sender compiledMethod ast allChildren 
				select: [ :child | child isMessage 
					and: [ child selector = #flag: ] ] ].

	^ nodes collect: [ :each | PulsarFlagModel fromNode: each ]
]

{ #category : 'private' }
PulsarFlagsModel >> currentModel [

	^ currentModel
]

{ #category : 'accessing' }
PulsarFlagsModel >> flags [

	^ flags ifNil: [ flags := self collectFlags ]
]

{ #category : 'testing' }
PulsarFlagsModel >> isScope: aSymbol [

	^ false
]

{ #category : 'accessing' }
PulsarFlagsModel >> locationDescriptionFor: aFlag [

	^ aFlag locationDescription
]

{ #category : 'instance creation' }
PulsarFlagsModel >> newActivationAnnouncementFor: aFlag [
	| announcement |

	announcement := PulsarModelActivated newValue: (PvMethodModel 
		newEnvironment: self environmentModel 
		entity: aFlag locationMethod).
	
	announcement selection: aFlag selection.
	
	^ announcement
]

{ #category : 'instance creation' }
PulsarFlagsModel >> newMethodModelFor: aMethod [

	^ PvMethodModel 
		newEnvironment: self environmentModel
		entity: aMethod
]

{ #category : 'private' }
PulsarFlagsModel >> newSystemNavigation [

	self flag: #TODO. "Using system navigation is wrong, this wont work on a remote environment. 
	I need to take this from the environment model."
	^ SystemNavigation new
		environment: self calculateEnvironment;
		yourself
]

{ #category : 'private' }
PulsarFlagsModel >> reset [

	flags := nil
]

{ #category : 'accessing' }
PulsarFlagsModel >> title [

	^ self subclassResponsibility
]

{ #category : 'updating' }
PulsarFlagsModel >> updateWith: aModel [
	| updatingModel |

	updatingModel := aModel accept: self.
	
	currentModel = updatingModel ifTrue: [ ^ false ].
	currentModel := updatingModel.
	self reset.
	
	^ true
]
