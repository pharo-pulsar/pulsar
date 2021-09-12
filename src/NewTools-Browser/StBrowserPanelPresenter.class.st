Class {
	#name : #StBrowserPanelPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : #'NewTools-Browser-View'
}

{ #category : #private }
StBrowserPanelPresenter >> iconNamed: aName [

	aName ifNil: [ ^ nil ].
	^ self application iconNamed: aName
]
