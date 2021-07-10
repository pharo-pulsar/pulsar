Extension { #name : #RPackage }

{ #category : #'*NewTools-Browser' }
RPackage >> browserClasses [
	
	^ self definedClasses asOrderedCollection
]

{ #category : #'*NewTools-Browser' }
RPackage >> browserName [
	
	^ self packageName
]

{ #category : #'*NewTools-Browser' }
RPackage >> browserPackageChildren [
	
	^ self actualClassTags asOrderedCollection
]
