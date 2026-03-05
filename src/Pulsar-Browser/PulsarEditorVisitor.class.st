Class {
	#name : 'PulsarEditorVisitor',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'accessing' }
PulsarEditorVisitor >> owner [

	^ owner
]

{ #category : 'initialization' }
PulsarEditorVisitor >> owner: anOwner [

	owner := anOwner
]

{ #category : 'visiting' }
PulsarEditorVisitor >> visit: aPresenter [

	^ aPresenter acceptVisitor: self
]

{ #category : 'visiting' }
PulsarEditorVisitor >> visitClassEditor: aPresenter [

	^ self visitEditor: aPresenter
]

{ #category : 'visiting' }
PulsarEditorVisitor >> visitContextEditor: aPresenter [

	^ self visitEditor: aPresenter
]

{ #category : 'visiting' }
PulsarEditorVisitor >> visitEditor: aPresenter [

	^ self visitPresenter: aPresenter
]

{ #category : 'visiting' }
PulsarEditorVisitor >> visitMethodEditor: aPresenter [

	^ self visitEditor: aPresenter
]

{ #category : 'visiting' }
PulsarEditorVisitor >> visitPresenter: aPresenter [

]
