Class {
	#name : #StProtocolModel,
	#superclass : #Object,
	#instVars : [
		'modelClass',
		'protocol'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #private }
StProtocolModel class >> classFor: aProtocol [
		
	^ self allSubclasses
		detect: [ :each | each isForProtocol: aProtocol ]
		ifFound: [ :aClass | aClass ]
		ifNone: [ StProtocolModel ]
]

{ #category : #testing }
StProtocolModel class >> isForProtocol: aProtocol [

	^ true
]

{ #category : #'instance creation' }
StProtocolModel class >> newClass: aClass protocol: aProtocol [

	^ (self classFor: aProtocol) new
		modelClass: aClass;
		protocol: aProtocol;
		yourself
]

{ #category : #accessing }
StProtocolModel >> iconName [

	self protocol isPrivate ifTrue: [ ^ #protocolPrivateIcon ].
	self protocol isProtected ifTrue: [ ^ #protocolProtectedIcon ].
	self protocol isExtensionProtocol ifTrue: [ ^ #protocolExtension ].
			
	^ #blank
]

{ #category : #accessing }
StProtocolModel >> methods [
	
	^ (self protocol methodSelectors 
		collect: [ :each | StMethodModel newMethod: self modelClass >> each ]
		as: OrderedCollection)
		sorted: #name ascending
]

{ #category : #accessing }
StProtocolModel >> modelClass [

	^ modelClass
]

{ #category : #accessing }
StProtocolModel >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
StProtocolModel >> name [

	^ self protocol name
]

{ #category : #accessing }
StProtocolModel >> order [

	^ 100
]

{ #category : #accessing }
StProtocolModel >> protocol [

	^ protocol
]

{ #category : #accessing }
StProtocolModel >> protocol: anObject [

	protocol := anObject
]
