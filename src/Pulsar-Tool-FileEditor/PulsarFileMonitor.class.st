"
A wrapper of GFileMonitor, used for monitoring files/directories.
"
Class {
	#name : 'PulsarFileMonitor',
	#superclass : 'Object',
	#instVars : [
		'gFile',
		'gMonitor',
		'batchMilliseconds',
		'changedAction',
		'changedWaiting',
		'mutex'
	],
	#category : 'Pulsar-Tool-FileEditor-Utilities',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Utilities'
}

{ #category : 'defaults' }
PulsarFileMonitor class >> defaultBatchMilliseconds [ 

	^ 100 milliSeconds
]

{ #category : 'instance creation' }
PulsarFileMonitor class >> newFrom: aFileReference [

	^ self new
		fromReference: aFileReference;
		yourself
]

{ #category : 'accessing' }
PulsarFileMonitor >> batchMilliseconds [

	^ batchMilliseconds ifNil: [ batchMilliseconds := self class defaultBatchMilliseconds ]
]

{ #category : 'accessing' }
PulsarFileMonitor >> batchMilliseconds: aDuration [

	batchMilliseconds := aDuration
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

{ #category : 'initialization' }
PulsarFileMonitor >> initialize [

	changedWaiting := false.
	mutex := Mutex new.
	super initialize.
]

{ #category : 'private' }
PulsarFileMonitor >> maybeStartChangedActivationBatch [

	changedWaiting ifTrue: [ ^ self ].
	
	changedWaiting := true.
	[ 
		self batchMilliseconds wait.
		changedWaiting := false.
		changedAction value 
	] fork
]

{ #category : 'events' }
PulsarFileMonitor >> startMonitoringDo: aBlock [

	changedAction := aBlock.
	self defer: [ 
		gMonitor connectChanged: [ :thisFile :otherFile :event |
			| otherRef |
			
			otherRef := otherFile isNullOrNil 
				ifTrue: [ nil ]
				ifFalse: [ otherFile path asFileReference ].
				
			self maybeStartChangedActivationBatch ] ]
]

{ #category : 'events' }
PulsarFileMonitor >> stopAndDispose [

	self flag: #FIXME. "I added the mutex because this is being called twice. While a security 
	flag does not hurts, is better to find the place where this is happening and fix it."
	mutex critical: [  
		gMonitor ifNil: [ ^ self ].
		self defer: [ 
			[ 
				gMonitor cancel.
				gMonitor objectUnref.
				gFile objectUnref.
			] 
			ensure: [ 
				gMonitor := gFile := nil ] ] ]
]
