Trait {
	#name : 'PvTToggeableAction',
	#instVars : [
		'state'
	],
	#category : 'Perspective-Command-Base',
	#package : 'Perspective',
	#tag : 'Command-Base'
}

{ #category : 'private' }
PvTToggeableAction >> specCommandClass [

	^ PvSpecToggleCommand
]

{ #category : 'accessing' }
PvTToggeableAction >> state [

	^ state ifNil: [ state := false ]
]

{ #category : 'accessing' }
PvTToggeableAction >> state: aBoolean [

	state := aBoolean
]

{ #category : 'accessing' }
PvTToggeableAction >> toggleState [

	self state: self state not
]
