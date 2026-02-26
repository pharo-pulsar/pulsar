"
Used to announce a ""unpin"" click on the stack row
"
Class {
	#name : 'PulsarStackUnpinEditor',
	#superclass : 'Announcement',
	#instVars : [
		'editor'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'instance creation' }
PulsarStackUnpinEditor class >> newEditor: anEditor [

	^ self new 
		editor: anEditor;
		yourself
]

{ #category : 'accessing' }
PulsarStackUnpinEditor >> editor [

	^ editor
]

{ #category : 'accessing' }
PulsarStackUnpinEditor >> editor: anEditor [

	editor := anEditor
]
