Class {
	#name : 'PvProtocolModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvProtocolModel class >> all [

	^ self 
		newEnvironment: nil 
		entity: Protocol new
]

{ #category : 'accessing' }
PvProtocolModel >> iconName [

	^ nil
]

{ #category : 'accessing' }
PvProtocolModel >> name [

	^ self entity name
]

{ #category : 'accessing' }
PvProtocolModel >> selectors [
	
	^ self entity methodSelectors
]
