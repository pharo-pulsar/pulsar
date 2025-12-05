Trait {
	#name : 'DockTActionContainer',
	#instVars : [
		'actions'
	],
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'private' }
DockTActionContainer >> actions [

	^ actions ifNil: [ actions := DockActionCollector collectFor: self ]
]
