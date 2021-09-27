Class {
	#name : #StClassModel,
	#superclass : #StBaseClassModel,
	#category : #'NewTools-Browser-Model-Class'
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
		StBrowserClassDefinitionPresenter on: self.
		StBrowserMethodTemplateEditorPresenter on: (StMethodTemplateModel newClass: self modelClass)
	}
]

{ #category : #accessing }
StClassModel >> shortName [
	
	^ self name contractTo: self class shortSize
]
