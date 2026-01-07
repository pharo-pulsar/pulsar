Extension { #name : 'PvBaseModel' }

{ #category : '*Pulsar-Browser' }
PvBaseModel >> hasPulsarEditor [

	^ self dockEditorClass isNotNil
]
