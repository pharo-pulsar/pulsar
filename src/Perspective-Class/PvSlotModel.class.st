Class {
	#name : #PvSlotModel,
	#superclass : #PvEntityModel,
	#category : #'Perspective-Class-Model'
}

{ #category : #accessing }
PvSlotModel >> iconName [

	^ 'variable'
]

{ #category : #accessing }
PvSlotModel >> name [

	^ self entity name
]
