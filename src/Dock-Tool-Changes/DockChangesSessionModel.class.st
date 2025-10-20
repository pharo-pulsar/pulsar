Class {
	#name : 'DockChangesSessionModel',
	#superclass : 'Object',
	#instVars : [
		'fileReference',
		'entries',
		'isRedo'
	],
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'instance creation' }
DockChangesSessionModel class >> newFileReference: aFileReference [

	^ self new 
		fileReference: aFileReference;
		yourself
]

{ #category : 'instance creation' }
DockChangesSessionModel class >> newFileReference: aFileReference entries: aCollection [

	^ self new 
		fileReference: aFileReference;
		entries: aCollection;
		yourself
]

{ #category : 'accessing' }
DockChangesSessionModel >> actionName [

	^ self isUndo
		ifTrue: [ 'Revert' ]
		ifFalse: [ 'Apply' ]
]

{ #category : 'accessing' }
DockChangesSessionModel >> beForRedo [

	isRedo := true
]

{ #category : 'accessing' }
DockChangesSessionModel >> beForUndo [

	isRedo := false
]

{ #category : 'accessing' }
DockChangesSessionModel >> entries [

	^ entries ifNil: [ entries := self retrieveEntries ]
]

{ #category : 'initialization' }
DockChangesSessionModel >> entries: aCollection [

	entries := aCollection
]

{ #category : 'accessing' }
DockChangesSessionModel >> fileReference [

	^ fileReference
]

{ #category : 'initialization' }
DockChangesSessionModel >> fileReference: aFileReference [

	fileReference := aFileReference
]

{ #category : 'initialization' }
DockChangesSessionModel >> initialize [

	super initialize. 
	self beForUndo
]

{ #category : 'testing' }
DockChangesSessionModel >> isRedo [

	^ isRedo
]

{ #category : 'testing' }
DockChangesSessionModel >> isUndo [

	^ self isRedo not
]

{ #category : 'private' }
DockChangesSessionModel >> performAction [
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
DockChangesSessionModel >> retrieveEntries [

	self fileReference ifNil: [ ^ #() ].
	
	^ (OmFileStore fromFile: self fileReference) entries reversed
]

{ #category : 'accessing' }
DockChangesSessionModel >> title [

	^ '{1} changes' format: { self actionName }
]
