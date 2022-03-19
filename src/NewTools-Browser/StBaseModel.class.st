Class {
	#name : #StBaseModel,
	#superclass : #Object,
	#category : #'NewTools-Browser-Model'
}

{ #category : #accessing }
StBaseModel >> associatedEditors [

	^ StBrowserAssociatedEditorSet new
]

{ #category : #accessing }
StBaseModel >> children [
	
	^ #()
]

{ #category : #accessing }
StBaseModel >> colorName [
	
	^ nil
]

{ #category : #accessing }
StBaseModel >> iconName [

	^ nil
]

{ #category : #accessing }
StBaseModel >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
StBaseModel >> pageTitle [

	^ self shortName
]

{ #category : #accessing }
StBaseModel >> shortName [

	^ self name
]

{ #category : #accessing }
StBaseModel >> windowIconName [

	^ self iconName
]

{ #category : #accessing }
StBaseModel >> windowTitle [

	^ self name
]
