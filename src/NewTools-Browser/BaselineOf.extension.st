Extension { #name : #BaselineOf }

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserClasses [
	
	^ self browserPackageChildren 
		flatCollect: [ :each | each browserClasses ]
		as: OrderedCollection
]

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserName [

	^ self name allButFirst: 10
]

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserPackageChildren [
	
	^ Array streamContents: [ :stream | 
		self version packages do: [ :aPackageSpec | 
			aPackageSpec browserPackage ifNotNil: [ :aPackage |
				stream << aPackage ] ] ]
]

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserPriority [
	"By default, all baselines have same priority, 100"

	^ 100
]
