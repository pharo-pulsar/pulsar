Class {
	#name : #PvPackageTagModel,
	#superclass : #PvEntityModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #'instance creation' }
PvPackageTagModel class >> newPackageTag: aPackageTag [

	^ self new 
		tag: aPackageTag;
		yourself
]

{ #category : #accessing }
PvPackageTagModel class >> order [

	^ 100
]

{ #category : #comparing }
PvPackageTagModel >> = other [

	^ self species = other species
		and: [ self entity = other entity ] 
]

{ #category : #accessing }
PvPackageTagModel >> children [

	^ self classes
]

{ #category : #accessing }
PvPackageTagModel >> classes [

	^ (self entity classes
		collect: [ :each | PvClassModel newEntity: each ]
		as: OrderedCollection)
		sorted: #name ascending
]

{ #category : #comparing }
PvPackageTagModel >> hash [

	^ self species hash
		bitXor: self entity hash
]

{ #category : #testing }
PvPackageTagModel >> isRoot [

	^ self entity isRoot
]

{ #category : #accessing }
PvPackageTagModel >> name [

	^ self entity name
]

{ #category : #accessing }
PvPackageTagModel >> order [

	^ self class order
]

{ #category : #accessing }
PvPackageTagModel >> package [

	^ self entity package
]
