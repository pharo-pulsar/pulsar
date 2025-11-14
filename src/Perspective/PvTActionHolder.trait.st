Trait {
	#name : 'PvTActionHolder',
	#instVars : [
		'actions'
	],
	#category : 'Perspective-View',
	#package : 'Perspective',
	#tag : 'View'
}

{ #category : 'accessing' }
PvTActionHolder >> actions [

	^ actions ifNil: [ actions := DockActionCollector collectFor: self ]
]

{ #category : 'accessing' }
PvTActionHolder >> contextMenuActionGroups [
		
	^ #()
]

{ #category : 'accessing' }
PvTActionHolder >> contextMenuActions [

	^ (self actions actionsForAll: self contextMenuActionGroups)
		beRoot;
		yourself
]
