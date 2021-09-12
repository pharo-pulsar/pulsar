Class {
	#name : #StClassModel,
	#superclass : #StBaseClassModel,
	#category : #'NewTools-Browser-Model'
}

{ #category : #'accessing - parallel hierarchy' }
StClassModel >> classSide [

	^ StMetaclassModel newClass: self modelClass classSide
]

{ #category : #'accessing - parallel hierarchy' }
StClassModel >> instanceSide [

	^ self
]

{ #category : #accessing }
StClassModel >> name [

	^ self modelClass name
]
