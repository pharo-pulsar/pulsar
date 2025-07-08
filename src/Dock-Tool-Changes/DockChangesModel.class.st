Class {
	#name : 'DockChangesModel',
	#superclass : 'Object',
	#instVars : [
		'logFiles'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'private' }
DockChangesModel >> directory [

	^ self monitor sessionStore baseLocator
]

{ #category : 'as yet unclassified' }
DockChangesModel >> entriesOnReference: aFileReference [

	aFileReference ifNil: [ ^ #() ].

	^ (OmFileStore fromFile: aFileReference) entries reversed
]

{ #category : 'accessing' }
DockChangesModel >> logFiles [

	^ logFiles ifNil: [ logFiles := self retrieveLogFiles ]
]

{ #category : 'private' }
DockChangesModel >> monitor [

	^ EpMonitor current
]

{ #category : 'private' }
DockChangesModel >> retrieveLogFiles [
	| files |

	"This should be just get the files and sort by modificationTime but doign that 
	 is very slow in large systems (because it does the call to get the time each time
	 the sorter pases). To be mor efficient, first I collect the time and then I sort."
	files := (self directory filesMatching: '*', OmFileStore defaultFileSuffix) 
		collect: [ :each | { each. each modificationTime } ].
	
	^ (files sort: #second descending) collect: #first
]
