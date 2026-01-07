Class {
	#name : 'PulsarChangesSessionModel',
	#superclass : 'Object',
	#instVars : [
		'fileReference',
		'entries',
		'isRedo'
	],
	#category : 'Pulsar-Tool-Changes',
	#package : 'Pulsar-Tool-Changes'
}

{ #category : 'instance creation' }
PulsarChangesSessionModel class >> newFileReference: aFileReference [

	^ self new 
		fileReference: aFileReference;
		yourself
]

{ #category : 'instance creation' }
PulsarChangesSessionModel class >> newFileReference: aFileReference entries: aCollection [

	^ self new 
		fileReference: aFileReference;
		entries: aCollection;
		yourself
]

{ #category : 'accessing' }
PulsarChangesSessionModel >> actionName [

	^ self isUndo
		ifTrue: [ 'Revert' ]
		ifFalse: [ 'Apply' ]
]

{ #category : 'accessing' }
PulsarChangesSessionModel >> beForRedo [

	isRedo := true
]

{ #category : 'accessing' }
PulsarChangesSessionModel >> beForUndo [

	isRedo := false
]

{ #category : 'accessing' }
PulsarChangesSessionModel >> entries [

	^ entries ifNil: [ entries := self retrieveEntries ]
]

{ #category : 'initialization' }
PulsarChangesSessionModel >> entries: aCollection [

	entries := aCollection
]

{ #category : 'accessing' }
PulsarChangesSessionModel >> fileReference [

	^ fileReference
]

{ #category : 'initialization' }
PulsarChangesSessionModel >> fileReference: aFileReference [

	fileReference := aFileReference
]

{ #category : 'initialization' }
PulsarChangesSessionModel >> initialize [

	super initialize. 
	self beForUndo
]

{ #category : 'testing' }
PulsarChangesSessionModel >> isRedo [

	^ isRedo
]

{ #category : 'testing' }
PulsarChangesSessionModel >> isUndo [

	^ self isRedo not
]

{ #category : 'private' }
PulsarChangesSessionModel >> performAction [
	| entriesToOperate |
	
	"if is undo, collect reverted code change"
	entriesToOperate := entries collect: [ :each |
		self isUndo
			ifTrue: [ each content asRevertedCodeChange ]
			ifFalse: [ each content ] ].
		
	entriesToOperate do: [ :each | 
		each applyCodeChange ]
]

{ #category : 'private' }
PulsarChangesSessionModel >> retrieveEntries [

	self fileReference ifNil: [ ^ #() ].
	
	^ (OmFileStore fromFile: self fileReference) entries reversed
]

{ #category : 'accessing' }
PulsarChangesSessionModel >> title [

	^ '{1} changes' format: { self actionName }
]
