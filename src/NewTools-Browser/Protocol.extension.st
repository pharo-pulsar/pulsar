Extension { #name : #Protocol }

{ #category : #'*NewTools-Browser' }
Protocol >> isAllProtocol [ 

	^ false
]

{ #category : #'*NewTools-Browser' }
Protocol >> isPrivate [

	^ self name asLowercase beginsWith: 'private'
]

{ #category : #'*NewTools-Browser' }
Protocol >> isProtected [
	| lowercaseName |

	lowercaseName := self name asLowercase.
	^ #('initial' 'class initial' 'releaz' 'releas' 'finali') 
		anySatisfy: [ :each | lowercaseName beginsWith: each ]
]
