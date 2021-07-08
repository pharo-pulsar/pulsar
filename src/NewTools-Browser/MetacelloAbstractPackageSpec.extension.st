Extension { #name : #MetacelloAbstractPackageSpec }

{ #category : #'*NewTools-Browser' }
MetacelloAbstractPackageSpec >> browserChildren [
	
	^ self browserClasses
]

{ #category : #'*NewTools-Browser' }
MetacelloAbstractPackageSpec >> browserClasses [
	
	^ (RPackageOrganizer default packageNamed: self name ifAbsent: [ nil ])
		ifNotNil: [ :aPackage | aPackage definedClasses asOrderedCollection ] 
		ifNil: [ #() ]
]

{ #category : #'*NewTools-Browser' }
MetacelloAbstractPackageSpec >> browserName [
	
	^ self name
]
