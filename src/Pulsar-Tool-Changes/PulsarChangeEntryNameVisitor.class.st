Class {
	#name : 'PulsarChangeEntryNameVisitor',
	#superclass : 'EpEntryContentVisitor',
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitBehaviorCommentChange: aChange [

	^ '<b>', aChange behaviorAffectedName, '</b> <small>[comment]</small>'
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitClassChange: aChange [

	^ '<b>', aChange behaviorAffectedName, '</b>'
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitEvent: aChange [

	^ aChange asString
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitMethodAddition: aMethodCreatedChange [

	^ '<b>{1}</b> » {2}' format: {
		aMethodCreatedChange behaviorAffectedName.
		aMethodCreatedChange methodAdded selector }
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitMethodModification: aMethodModified [

	^ '<b>{1}</b> » {2}' format: {
		aMethodModified behaviorAffectedName. 
		aMethodModified oldMethod selector }
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitMethodRemoval: aMethodRemoved [

	^ '<b>{1}</b> » {2}' format: {
		aMethodRemoved behaviorAffectedName.
		aMethodRemoved methodRemoved selector }
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitProtocolAddition: aProtocolChange [

	^ '<b>{1}</b> <small><u>[protocol]</u></small> {2}' format: { 
		aProtocolChange behaviorAffectedName. 
		aProtocolChange protocol }
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitProtocolRemoval: aProtocolChange [

	^ self visitProtocolAddition: aProtocolChange
]

{ #category : 'visitor' }
PulsarChangeEntryNameVisitor >> visitSessionSnapshot: anEvent [

	^ '<b>Snapshot:</b> ', anEvent imageName
]
