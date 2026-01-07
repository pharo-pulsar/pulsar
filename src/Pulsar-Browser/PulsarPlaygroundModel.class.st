Class {
	#name : 'PulsarPlaygroundModel',
	#superclass : 'Object',
	#instVars : [
		'page'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'accessing' }
PulsarPlaygroundModel >> contents [

	^ page contents
]

{ #category : 'accessing' }
PulsarPlaygroundModel >> contents: aString [

	page contents: aString
]

{ #category : 'initialization' }
PulsarPlaygroundModel >> initialize [

	super initialize.
	page := StPlaygroundPage new
]

{ #category : 'accessing' }
PulsarPlaygroundModel >> loadPage: aPage [

	page := aPage
]

{ #category : 'instance creation' }
PulsarPlaygroundModel >> newVersionsModel [

	^ PulsarPlaygroundVersionsModel newPage: page
]
