"
A wrapper of GFileMonitor, used for monitoring files/directories.
"
Class {
	#name : 'PulsarFileMonitor',
	#superclass : 'Object',
	#classVars : [
		'gFile',
		'gMonitor'
	],
	#category : 'Pulsar-Tool-FileEditor-Utilities',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Utilities'
}

{ #category : 'instance creation' }
PulsarFileMonitor class >> newFrom: aFileReference [

	^ self new
		fromReference: aFileReference;
		yourself
]

{ #category : 'private' }
PulsarFileMonitor >> defer: aBlock [

	^ GRunLoop defer: aBlock
]

{ #category : 'initialization' }
PulsarFileMonitor >> fromReference: aFileReference [

	self defer: [ 
		gFile := GFile forPath: aFileReference fullName.
		gMonitor := aFileReference isDirectory
			ifTrue: [ gFile monitorDirectory ] 
			ifFalse: [ gFile monitorFile ] ]
]

{ #category : 'stopping' }
PulsarFileMonitor >> stopAndDispose [

	self defer: [ 
		gMonitor cancel.
		gMonitor objectUnref.
		gFile objectUnref ]
]

{ #category : 'events' }
PulsarFileMonitor >> whenChangedDo: aBlock [

	self defer: [ 
		gMonitor connectChanged: [ :thisFile :otherFile :event |
			| otherRef |
			
			otherRef := otherFile isNullOrNil 
				ifTrue: [ nil ]
				ifFalse: [ otherFile path asFileReference ].
				
			aBlock
				value: otherRef 
				value: event ] ]
]
