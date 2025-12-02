"
A base for all flags.
"
Class {
	#name : 'DockFlagsModel',
	#superclass : 'Object',
	#traits : 'DockTEnvironmentModel + DockTModelVisitor',
	#classTraits : 'DockTEnvironmentModel classTrait + DockTModelVisitor classTrait',
	#instVars : [
		'flags',
		'changeAction',
		'currentModel'
	],
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'accessing' }
DockFlagsModel class >> defaultScopeClass [

	^ self subclasses detect: [ :each | each isDefault ]
]

{ #category : 'testing' }
DockFlagsModel class >> isDefault [

	^ false
]

{ #category : 'private' }
DockFlagsModel >> calculateEnvironment [

	self subclassResponsibility
]

{ #category : 'private' }
DockFlagsModel >> collectFlags [
	| nodes |

	nodes := (self newSystemNavigation allSendersOf: #flag:)
		flatCollect: [ :sender | 
			sender compiledMethod ast allChildren 
				select: [ :child | child isMessage 
					and: [ child selector = #flag: ] ] ].

	^ nodes collect: [ :each | DockFlagModel fromNode: each ]
]

{ #category : 'private' }
DockFlagsModel >> currentModel [

	^ currentModel
]

{ #category : 'accessing' }
DockFlagsModel >> flags [

	^ flags ifNil: [ flags := self collectFlags ]
]

{ #category : 'testing' }
DockFlagsModel >> isScope: aSymbol [

	^ false
]

{ #category : 'accessing' }
DockFlagsModel >> locationDescriptionFor: aFlag [

	^ aFlag locationDescription
]

{ #category : 'instance creation' }
DockFlagsModel >> newActivationAnnouncementFor: aFlag [
	| announcement |

	announcement := DockModelActivated newValue: (PvMethodModel 
		newEnvironment: self environmentModel 
		entity: aFlag locationMethod).
	
	announcement selection: aFlag selection.
	
	^ announcement
]

{ #category : 'private' }
DockFlagsModel >> newSystemNavigation [

	self flag: #TODO. "Using system navigation is wrong, this wont work on a remote environment. 
	I need to take this from the environment model."
	^ SystemNavigation new
		environment: self calculateEnvironment;
		yourself
]

{ #category : 'private' }
DockFlagsModel >> reset [

	flags := nil
]

{ #category : 'accessing' }
DockFlagsModel >> title [

	^ self subclassResponsibility
]

{ #category : 'updating' }
DockFlagsModel >> updateWith: aModel [
	| updatingModel |

	updatingModel := aModel accept: self.
	currentModel = updatingModel ifTrue: [ ^ false ].
	currentModel := updatingModel.
	self reset.
	
	^ true
]
