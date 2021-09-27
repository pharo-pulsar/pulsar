Class {
	#name : #StProtocolModel,
	#superclass : #StBaseModel,
	#instVars : [
		'modelClass',
		'protocol'
	],
	#category : #'NewTools-Browser-Model-Protocol'
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

{ #category : #comparing }
StProtocolModel >> = other [

	^ self species = other species 
		and: [ self protocol = other protocol ]
]

{ #category : #comparing }
StProtocolModel >> hash [

	^ self species hash 
		bitXor: self protocol hash
]

{ #category : #accessing }
StProtocolModel >> iconName [

	self protocol isPrivate ifTrue: [ ^ #protocolPrivateIcon ].
	self protocol isProtected ifTrue: [ ^ #protocolProtectedIcon ].
	self protocol isExtensionProtocol ifTrue: [ ^ #protocolExtension ].
			
	^ #protocolNone
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

{ #category : #accessing }
StProtocolModel >> windowName [

	^ self modelClass name
]
