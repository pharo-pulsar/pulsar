Class {
	#name : #StClassModel,
	#superclass : #StBaseClassModel,
	#category : #'NewTools-Browser-Model-Class'
}

{ #category : #accessing }
StClassModel >> associatedEditors [

	^ StBrowserAssociatedEditorSet new 
		add: (StBrowserClassCommentPresenter on: self); 
		addDefault: (StBrowserClassDefinitionPresenter on: self);
		add: (StBrowserMethodTemplateEditorPresenter on: (StMethodTemplateModel newClass: self modelClass));
		yourself
]

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

{ #category : #'accessing - parallel hierarchy' }
StClassModel >> instanceSide [

	^ self
]

{ #category : #accessing }
StClassModel >> name [

	^ self modelClass name asString
]

{ #category : #accessing }
StClassModel >> shortName [
	
	^ self name contractTo: self class shortSize
]

{ #category : #accessing }
StClassModel >> windowCommentIconName [

	^ self modelClass hasComment
		ifTrue: [ #comments ]
		ifFalse: [ #uncommentedClass ]
]
