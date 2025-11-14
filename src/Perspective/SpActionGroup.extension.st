Extension { #name : 'SpActionGroup' }

{ #category : '*Perspective' }
SpActionGroup >> actionsFor: groupId [

	^ self groups 
		detect: [ :each | each id = groupId ]
		ifNone: [ self class new ]
]

{ #category : '*Perspective' }
SpActionGroup >> actionsForAll: aCollectionOfNames [

	^ aCollectionOfNames
		inject: PvActionGroup new asSpecGroup
		into: [ :all :each | | group |
			group := (self actionsFor: each).
			group hasEntries
				ifTrue: [ all register: group ].
			all ]
]

{ #category : '*Perspective' }
SpActionGroup >> entries: aCollection [

	self decoratedGroup entries: aCollection
]

{ #category : '*Perspective' }
SpActionGroup >> hasEntries [

	^ self entries isNotEmpty
]
