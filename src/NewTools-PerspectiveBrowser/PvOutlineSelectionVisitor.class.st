Class {
	#name : #PvOutlineSelectionVisitor,
	#superclass : #Object,
	#traits : 'PvTModelVisitor',
	#classTraits : 'PvTModelVisitor classTrait',
	#instVars : [
		'presenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Outline'
}

{ #category : #accessing }
PvOutlineSelectionVisitor >> presenter [
	
	^ presenter
]

{ #category : #accessing }
PvOutlineSelectionVisitor >> presenter: aPresenter [
	
	presenter := aPresenter
]

{ #category : #visiting }
PvOutlineSelectionVisitor >> visitMethodModel: aModel [
	| classModel |

	self presenter treePresenter selectedItem = aModel 
		ifTrue: [ ^ self ].

	classModel := PvOutlineClassModel newEntity: aModel methodClass.
	self presenter model = classModel
		ifFalse: [ self presenter model: classModel ].
	self presenter treePresenter selectItem: aModel.
]
