Extension { #name : #RPackageTag }

{ #category : #'*NewTools-Browser' }
RPackageTag >> browserClasses [
	
	^ self classes asOrderedCollection
]

{ #category : #'*NewTools-Browser' }
RPackageTag >> browserName [
	
	^ self name
]

{ #category : #'*NewTools-Browser' }
RPackageTag >> browserPackageChildren [
	
	^ #()
]
