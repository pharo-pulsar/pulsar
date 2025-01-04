Class {
	#name : 'PvSlotModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvSlotModel >> iconName [

	^ 'variable'
]

{ #category : 'testing' }
PvSlotModel >> isIncludedIn: aMethodModel [

	^ aMethodModel entity variableNodes anySatisfy: [ :each | each name = self name ]
]

{ #category : 'accessing' }
PvSlotModel >> name [

	^ self entity name
]
