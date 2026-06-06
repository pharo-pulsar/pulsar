Class {
	#name : 'PulsarPragmaCollector',
	#superclass : 'Object',
	#category : 'Pulsar-Browser-Utilities',
	#package : 'Pulsar-Browser',
	#tag : 'Utilities'
}

{ #category : 'accessing' }
PulsarPragmaCollector class >> collectPragma: aSelector in: anObject [

	^ self new 
		collectPragma: aSelector 
		in: anObject
]

{ #category : 'accessing' }
PulsarPragmaCollector class >> collectPragma: aSelector in: anObject withArguments: aCollection [

	^ self new 
		collectPragma: aSelector 
		in: anObject
		withArguments: aCollection
]

{ #category : 'accessing' }
PulsarPragmaCollector class >> traversePragma: aSelector in: anObject withArguments: aCollection [

	^ self new 
		traversePragma: aSelector 
		in: anObject 
		withArguments: aCollection
]

{ #category : 'accessing' }
PulsarPragmaCollector >> collectPragma: aSelector in: anObject [

	^ self collectPragma: aSelector in: anObject withArguments: #()
]

{ #category : 'accessing' }
PulsarPragmaCollector >> collectPragma: aSelector in: anObject withArguments: aCollection [
	
	^ { anObject. anObject class } 
		flatCollect: [ :each | 
			(Pragma allNamed: aSelector in: each class) 
				collect: [ :eachPragma | 
					aCollection 
						ifNotNil: [ 
							each
								perform: eachPragma methodSelector 
								withEnoughArguments: aCollection ] 
						ifNil: [
							each perform: eachPragma methodSelector ] ] ]
]

{ #category : 'accessing' }
PulsarPragmaCollector >> traversePragma: aSelector in: anObject withArguments: aCollection [
	
	^ { anObject. anObject class } do: [ :each | 
		(Pragma allNamed: aSelector in: each class) do: [ :eachPragma | 
			aCollection 
				ifNotNil: [ 
					each
						perform: eachPragma methodSelector 
						withEnoughArguments: aCollection ] 
				ifNil: [
					each perform: eachPragma methodSelector ] ] ]
]
