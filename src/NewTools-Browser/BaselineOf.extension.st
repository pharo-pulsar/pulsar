Extension { #name : #BaselineOf }

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserChildren [
	
	^ self version packages asOrderedCollection
]

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserClasses [
	
	^ self version packages 
		flatCollect: [ :each | each browserChildren ]
		as: OrderedCollection
]

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserName [

	^ self name allButFirst: 10
]

{ #category : #'*NewTools-Browser' }
BaselineOf class >> browserPriority [
	"By default, all baselines have same priority, 100"

	^ 100
]
