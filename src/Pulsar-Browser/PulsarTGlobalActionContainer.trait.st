Trait {
	#name : 'PulsarTGlobalActionContainer',
	#instVars : [
		'globalActions'
	],
	#category : 'Pulsar-Browser-Actions',
	#package : 'Pulsar-Browser',
	#tag : 'Actions'
}

{ #category : 'private' }
PulsarTGlobalActionContainer >> globalActions [

	^ globalActions ifNil: [ globalActions := PulsarActionCollector collectFor: self ]
]
