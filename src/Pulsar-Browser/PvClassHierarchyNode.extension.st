Extension { #name : 'PvClassHierarchyNode' }

{ #category : '*Pulsar-Browser' }
PvClassHierarchyNode >> accept: aVisitor [

	^ self realModel accept: aVisitor
]

{ #category : '*Pulsar-Browser' }
PvClassHierarchyNode >> realModel [

	^ self element
]
