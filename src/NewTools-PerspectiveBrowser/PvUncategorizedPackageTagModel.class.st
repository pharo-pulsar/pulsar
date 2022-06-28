Class {
	#name : #PvUncategorizedPackageTagModel,
	#superclass : #PvVirtualPackageTagModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #testing }
PvUncategorizedPackageTagModel class >> canBeUsedFor: aPackage [

	^ (aPackage includesClassTagNamed: aPackage name)"
		and: [ (aPackage classesForClassTag: aPackage name) notEmpty ]"
]

{ #category : #accessing }
PvUncategorizedPackageTagModel class >> order [

	^ 0
]

{ #category : #accessing }
PvUncategorizedPackageTagModel >> children [

	^ self classes
]

{ #category : #accessing }
PvUncategorizedPackageTagModel >> classes [

	^ ((self entity classesForClassTag: self entity name) 
		collect: [ :each | PvClassModel newEntity: each ])
		sorted: #name ascending
]

{ #category : #accessing }
PvUncategorizedPackageTagModel >> name [

	^ 'Uncategorized'
]
