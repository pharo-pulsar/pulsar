Class {
	#name : #StMetaclassModel,
	#superclass : #StBaseClassModel,
	#category : #'NewTools-Browser-Model-Class'
}

{ #category : #'accessing - parallel hierarchy' }
StMetaclassModel >> classSide [

	^ self
]

{ #category : #'accessing - parallel hierarchy' }
StMetaclassModel >> instanceSide [

	^ StClassModel newClass: self modelClass instanceSide
]

{ #category : #accessing }
StMetaclassModel >> name [

	^ self modelClass instanceSide name
]

{ #category : #'instance creation' }
StMetaclassModel >> newProtocolModelFor: aProtocol [

	^ StProtocolModel newClass: self modelClass protocol: aProtocol
]
