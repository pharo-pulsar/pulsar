Class {
	#name : #StPackageTagModel,
	#superclass : #StBasePackageTagModel,
	#instVars : [
		'tag'
	],
	#category : #'NewTools-Browser-Model'
}

{ #category : #'instance creation' }
StPackageTagModel class >> newPackageTag: aPackageTag [

	^ self new 
		tag: aPackageTag;
		yourself
]

{ #category : #accessing }
StPackageTagModel >> classes [

	^ self tag classes
		collect: [ :each | StClassModel newClass: each ]
		as: OrderedCollection
]

{ #category : #accessing }
StPackageTagModel >> name [

	^ self tag name
]

{ #category : #accessing }
StPackageTagModel >> tag [

	^ tag
]

{ #category : #accessing }
StPackageTagModel >> tag: aTag [

	tag := aTag
]
