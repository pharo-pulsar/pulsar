Extension { #name : #MetacelloAbstractPackageSpec }

{ #category : #'*NewTools-Browser' }
MetacelloAbstractPackageSpec >> browserPackage [
	
	^ RPackageOrganizer default 
		packageNamed: self name 
		ifAbsent: [ nil ]
]
