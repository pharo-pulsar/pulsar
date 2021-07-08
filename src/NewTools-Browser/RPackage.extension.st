Extension { #name : #RPackage }

{ #category : #'*NewTools-Browser' }
RPackage >> browserChildren [
	
	^ #()
]

{ #category : #'*NewTools-Browser' }
RPackage >> browserClasses [
	
	^ self definedClasses
]

{ #category : #'*NewTools-Browser' }
RPackage >> browserName [
	
	^ self packageName
]
