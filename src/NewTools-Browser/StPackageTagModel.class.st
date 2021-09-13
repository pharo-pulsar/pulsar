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

{ #category : #comparing }
StPackageTagModel >> = other [

	^ self species = other species
		and: [ self tag = other tag ] 
]

{ #category : #accessing }
StPackageTagModel >> classes [

	^ self tag classes
		collect: [ :each | StClassModel newClass: each ]
		as: OrderedCollection
]

{ #category : #comparing }
StPackageTagModel >> hash [

	^ self species hash
		bitXor: self tag hash
]

{ #category : #testing }
StPackageTagModel >> isRoot [

	^ self tag isRoot
]

{ #category : #accessing }
StPackageTagModel >> name [

	^ self tag name
]

{ #category : #accessing }
StPackageTagModel >> package [

	^ self tag package
]

{ #category : #accessing }
StPackageTagModel >> tag [

	^ tag
]

{ #category : #accessing }
StPackageTagModel >> tag: aTag [

	tag := aTag
]
