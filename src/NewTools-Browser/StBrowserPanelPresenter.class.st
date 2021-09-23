Class {
	#name : #StBrowserPanelPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : #'NewTools-Browser-View'
}

{ #category : #private }
StBrowserPanelPresenter >> colorNamed: aString [

	self flag: #TODO. "Hardcoded. This has to be part of StPharoApplication"
	aString ifNil: [ ^ Smalltalk ui theme textColor ].
	^ Color named: aString
]

{ #category : #private }
StBrowserPanelPresenter >> iconNamed: aName [

	aName ifNil: [ ^ nil ].
	^ self application iconNamed: aName
]
