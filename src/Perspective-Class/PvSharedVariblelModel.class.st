Class {
	#name : 'PvSharedVariblelModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'name'
	],
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvSharedVariblelModel class >> newEnvironment: anEnvironmentModel entity: anObject name: aName [

	^ self basicNew 
		environmentModel: anEnvironmentModel;
		entity: anObject;
		name: aName;
		initialize;
		yourself
]

{ #category : 'accessing' }
PvSharedVariblelModel >> iconName [

	^ nil
]

{ #category : 'accessing' }
PvSharedVariblelModel >> name [

	^ name
]

{ #category : 'accessing' }
PvSharedVariblelModel >> name: aName [

	name := aName
]
