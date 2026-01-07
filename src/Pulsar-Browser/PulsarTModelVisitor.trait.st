Trait {
	#name : 'PulsarTModelVisitor',
	#category : 'Pulsar-Browser-Base',
	#package : 'Pulsar-Browser',
	#tag : 'Base'
}

{ #category : 'visiting' }
PulsarTModelVisitor >> visitClassModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
PulsarTModelVisitor >> visitMethodModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
PulsarTModelVisitor >> visitModel: aModel [

	^ nil
]

{ #category : 'visiting' }
PulsarTModelVisitor >> visitPackageModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
PulsarTModelVisitor >> visitPackageTagModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
PulsarTModelVisitor >> visitProjectModel: aModel [

	^ self visitModel: aModel
]
