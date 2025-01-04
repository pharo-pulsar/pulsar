Class {
	#name : 'PvSharedVaribleModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'name'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvSharedVaribleModel class >> newEnvironment: anEnvironmentModel entity: anObject name: aName [

	^ self basicNew 
		environmentModel: anEnvironmentModel;
		entity: anObject;
		name: aName;
		initialize;
		yourself
]

{ #category : 'accessing' }
PvSharedVaribleModel >> iconName [

	^ nil
]

{ #category : 'accessing' }
PvSharedVaribleModel >> name [

	^ name
]

{ #category : 'accessing' }
PvSharedVaribleModel >> name: aName [

	name := aName
]
