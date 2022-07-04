Class {
	#name : #PvOutlineSelectionVisitor,
	#superclass : #Object,
	#instVars : [
		'presenter'
	],
	#category : #'Perspective-Class-View'
}

{ #category : #visiting }
PvOutlineSelectionVisitor >> methodSelected: aModel [
	| classModel |

	self presenter treePresenter selectedItem = aModel 
		ifTrue: [ ^ self ].

	classModel := aModel newOutlineClassModel.
	self presenter model = classModel
		ifFalse: [ self presenter model: classModel ].
	self presenter treePresenter selectItem: aModel
]

{ #category : #accessing }
PvOutlineSelectionVisitor >> presenter [
	
	^ presenter
]

{ #category : #accessing }
PvOutlineSelectionVisitor >> presenter: aPresenter [
	
	presenter := aPresenter
]
