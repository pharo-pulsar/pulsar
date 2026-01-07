Class {
	#name : 'PulsarWorker',
	#superclass : 'TKTWorker',
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
PulsarWorker >> inTool: aClass [

	^ self name: ('{TOOL}-{ID}' format: {#TOOL -> aClass name. #ID -> UUID new} asDictionary)
]
