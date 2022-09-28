Trait {
	#name : #PvTActionHolder,
	#instVars : [
		'actions'
	],
	#category : #'Perspective-View'
}

{ #category : #accessing }
PvTActionHolder >> actions [

	^ actions ifNil: [ actions := PvActionCollector collectFor: self ]
]

{ #category : #accessing }
PvTActionHolder >> contextMenuActionGroups [
		
	^ #()
]

{ #category : #accessing }
PvTActionHolder >> contextMenuActions [

	^ (self actions actionsForAll: self contextMenuActionGroups)
		beRoot;
		yourself
]
