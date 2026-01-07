Class {
	#name : 'PulsarChangesModel',
	#superclass : 'Object',
	#instVars : [
		'logFiles'
	],
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'private' }
PulsarChangesModel >> directory [

	^ self monitor sessionStore baseLocator
]

{ #category : 'accessing' }
PulsarChangesModel >> logFiles [

	^ logFiles ifNil: [ logFiles := self retrieveLogFiles ]
]

{ #category : 'private' }
PulsarChangesModel >> monitor [

	^ EpMonitor current
]

{ #category : 'private' }
PulsarChangesModel >> retrieveLogFiles [
	| files |

	"This should be just get the files and sort by modificationTime but doign that 
	 is very slow in large systems (because it does the call to get the time each time
	 the sorter pases). To be mor efficient, first I collect the time and then I sort."
	files := (self directory filesMatching: '*', OmFileStore defaultFileSuffix) 
		collect: [ :each | { each. each modificationTime } ].
	
	^ (files sort: #second descending) collect: #first
]
