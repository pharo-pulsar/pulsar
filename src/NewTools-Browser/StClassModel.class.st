Class {
	#name : #StClassModel,
	#superclass : #StBaseClassModel,
	#category : #'NewTools-Browser-Model'
}

{ #category : #accessing }
StClassModel >> classDefinition [

	^ self modelClass definitionString
]

{ #category : #'accessing - parallel hierarchy' }
StClassModel >> classSide [

	^ StMetaclassModel newClass: self modelClass classSide
]

{ #category : #accessing }
StClassModel >> comment [

	^ self modelClass comment
]

{ #category : #accessing }
StClassModel >> commentIconName [

	^ self modelClass hasComment
		ifTrue: [ #comments ]
		ifFalse: [ #uncommentedClass ]
]

{ #category : #'accessing - parallel hierarchy' }
StClassModel >> instanceSide [

	^ self
]

{ #category : #accessing }
StClassModel >> name [

	^ self modelClass name
]

{ #category : #'instance creation' }
StClassModel >> newEditors [

	^ { 
		StBrowserClassCommentPresenter on: self. 
		StBrowserClassDefinitionPresenter on: self
	}
]

{ #category : #default }
StClassModel >> shortName [
	
	^ self name contractTo: self class shortSize
]
