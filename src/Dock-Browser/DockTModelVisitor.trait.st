Trait {
	#name : 'DockTModelVisitor',
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
}

{ #category : 'visiting' }
DockTModelVisitor >> visitClassModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
DockTModelVisitor >> visitMethodModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
DockTModelVisitor >> visitModel: aModel [

	^ nil
]

{ #category : 'visiting' }
DockTModelVisitor >> visitPackageModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
DockTModelVisitor >> visitPackageTagModel: aModel [

	^ self visitModel: aModel
]

{ #category : 'visiting' }
DockTModelVisitor >> visitProjectModel: aModel [

	^ self visitModel: aModel
]
