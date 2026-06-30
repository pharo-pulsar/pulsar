Class {
	#name : 'PulsarEmptyDiffNode',
	#superclass : 'PulsarDiffNode',
	#category : 'Pulsar-Tool-Repositories',
	#package : 'Pulsar-Tool-Repositories'
}

{ #category : 'private' }
PulsarEmptyDiffNode >> collectChildren [

	^ #()
]

{ #category : 'testing' }
PulsarEmptyDiffNode >> hasChanges [

	^ false
]

{ #category : 'accessing' }
PulsarEmptyDiffNode >> iconName [

	^ #diff
]

{ #category : 'testing' }
PulsarEmptyDiffNode >> isEmpty [

	^ true
]

{ #category : 'testing' }
PulsarEmptyDiffNode >> isRoot [

	^ false
]

{ #category : 'accessing' }
PulsarEmptyDiffNode >> name [
	
	^ 'No diff' 
]
