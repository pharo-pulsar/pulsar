Class {
	#name : 'PulsarPlaygroundVersionsModel',
	#superclass : 'Object',
	#traits : 'PulsarTModel + PulsarTModelSnapshot + PulsarTEditable',
	#classTraits : 'PulsarTModel classTrait + PulsarTModelSnapshot classTrait + PulsarTEditable classTrait',
	#instVars : [
		'page'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'instance creation' }
PulsarPlaygroundVersionsModel class >> newPage: aPage [

	^ self new
		page: aPage;
		yourself
]

{ #category : 'accessing' }
PulsarPlaygroundVersionsModel >> iconName [

	^ 'versions'
]

{ #category : 'accessing' }
PulsarPlaygroundVersionsModel >> name [

	^ 'Playground Versions'
]

{ #category : 'accessing' }
PulsarPlaygroundVersionsModel >> page [

	^ page
]

{ #category : 'accessing' }
PulsarPlaygroundVersionsModel >> page: aPage [

	page := aPage
]

{ #category : 'accessing' }
PulsarPlaygroundVersionsModel >> pulsarEditorClass [

	^ PulsarPlaygroundVersionsBrowser 
]

{ #category : 'accessing' }
PulsarPlaygroundVersionsModel >> title [

	^ 'Page history'
]

{ #category : 'accessing' }
PulsarPlaygroundVersionsModel >> versions [

	^ self page versions reversed
]
