Class {
	#name : 'PulsarPlaygroundModel',
	#superclass : 'Object',
	#traits : 'PulsarTEnvironmentModel + PulsarTModelSnapshot',
	#classTraits : 'PulsarTEnvironmentModel classTrait + PulsarTModelSnapshot classTrait',
	#instVars : [
		'page'
	],
	#category : 'Pulsar-Browser-Tool-Playground',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'accessing' }
PulsarPlaygroundModel >> activationAnnouncementClass [

	^ nil
]

{ #category : 'accessing' }
PulsarPlaygroundModel >> contents [

	^ page contents
]

{ #category : 'accessing' }
PulsarPlaygroundModel >> contents: aString [

	page contents: aString
]

{ #category : 'testing' }
PulsarPlaygroundModel >> includesClassModel [

	^ false
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

{ #category : 'private' }
PulsarPlaygroundModel >> prepareForSnapshot [
]

{ #category : 'accessing' }
PulsarPlaygroundModel >> selectionAnnouncementClass [

	^ nil
]
