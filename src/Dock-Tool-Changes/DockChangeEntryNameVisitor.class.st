Class {
	#name : 'DockChangeEntryNameVisitor',
	#superclass : 'EpEntryContentVisitor',
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitBehaviorCommentChange: aChange [

	^ '<b>', aChange behaviorAffectedName, '</b> <small>[comment]</small>'
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitClassChange: aChange [

	^ '<b>', aChange behaviorAffectedName, '</b>'
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitEvent: aChange [

	^ aChange asString
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitMethodAddition: aMethodCreatedChange [

	^ '<b>{1}</b> » {2}' format: {
		aMethodCreatedChange behaviorAffectedName.
		aMethodCreatedChange methodAdded selector }
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitMethodModification: aMethodModified [

	^ '<b>{1}</b> » {2}' format: {
		aMethodModified behaviorAffectedName. 
		aMethodModified oldMethod selector }
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitMethodRemoval: aMethodRemoved [

	^ '<b>{1}</b> » {2}' format: {
		aMethodRemoved behaviorAffectedName.
		aMethodRemoved methodRemoved selector }
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitProtocolAddition: aProtocolChange [

	^ '<b>{1}</b> <small><u>[protocol]</u></small> {2}' format: { 
		aProtocolChange behaviorAffectedName. 
		aProtocolChange protocol }
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitProtocolRemoval: aProtocolChange [

	^ self visitProtocolAddition: aProtocolChange
]

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitSessionSnapshot: anEvent [

	^ '<b>Snapshot:</b> ', anEvent imageName
]
