Extension { #name : 'EpMonitor' }

{ #category : '*Pulsar-Browser' }
EpMonitor class >> methodChangesOfClass: aClassName selector: aSelector sinceDays: anIntegerOrNil [
	"Answer EpMethodChange events for aClassName>>aSelector from Epicea logs.
     anIntegerOrNil limits to the last N days; nil means no time limit.
     Returns an OrderedCollection of Association timestamp -> event, newest first."

	| logsDir cutoff events seenSources scanLogClosure |
	events := OrderedCollection new.
	seenSources := Set new.

	scanLogClosure := [ :log :timestamp |
		                  log entriesDo: [ :entry |
				                  | event |
				                  event := entry content.
				                  (event isEpMethodChange and: [
					                   event behaviorAffectedName = aClassName and: [ event methodAffectedSelector = aSelector ] ]) ifTrue: [
						                  | source |
						                  source := event methodAffectedSourceCode.
						                  (seenSources includes: source) ifFalse: [
								                  seenSources add: source.
								                  events add: timestamp -> event ] ] ] ].

	logsDir := self current sessionStore baseLocator asFileReference.
	cutoff := anIntegerOrNil ifNotNil: [ DateAndTime now - anIntegerOrNil days ] ifNil: [ DateAndTime epoch ].

	"Scan past session ombu files"
	logsDir children
		select: [ :eachFile | eachFile extension = 'ombu' and: [ eachFile modificationTime >= cutoff ] ]
		thenDo: [ :eachFile |
				| log |
				log := [ EpLog freshFromFile: eachFile ]
					       on: Error
					       do: [ nil ].
				log ifNotNil: [
						[ scanLogClosure value: log value: eachFile modificationTime ]
							on: Error
							do: [ "skip corrupt files" ] ] ].

	"Current session (unflushed entries)"
	scanLogClosure value: EpMonitor current log value: DateAndTime now.

	^ events sort: [ :a :b | a key > b key ]
]

{ #category : '*Pulsar-Browser' }
EpMonitor class >> versionsOfClass: aClassName selector: aSelector sinceDays: anIntegerOrNil [
	"Answer RGMethodDefinition objects for aClassName>>aSelector from Epicea logs.
     anIntegerOrNil limits to the last N days; nil means no time limit.
     Returns an OrderedCollection of RGMethodDefinition, newest first."

	^ (self methodChangesOfClass: aClassName selector: aSelector sinceDays: anIntegerOrNil) collect: [ :eachAssociation |
		  eachAssociation value methodAffected ]
]
