Trait {
	#name : 'PulsarTActionContainer',
	#instVars : [
		'actions'
	],
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'private' }
PulsarTActionContainer >> actions [

	^ actions ifNil: [ actions := PulsarActionCollector collectFor: self ]
]
