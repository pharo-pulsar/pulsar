Class {
	#name : 'PulsarBaseSnapshot',
	#superclass : 'Object',
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'instance creation' }
PulsarBaseSnapshot class >> on: aPresenter [

	^ self new snapshot: aPresenter
]

{ #category : 'accessing' }
PulsarBaseSnapshot >> restorePriority [

	^ 100
]

{ #category : 'restoring' }
PulsarBaseSnapshot >> restoreTo: aPresenter [

]

{ #category : 'initialization' }
PulsarBaseSnapshot >> snapshot: anObject [

	self subclassResponsibility
]
