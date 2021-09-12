Class {
	#name : #StBrowserEditorPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : #'NewTools-Browser-View'
}

{ #category : #adding }
StBrowserEditorPresenter >> addToNotebook: aNotebook [

	self subclassResponsibility
]

{ #category : #testing }
StBrowserEditorPresenter >> isMethodEditor [

	^ false
]
