Class {
	#name : #StBrowserPanelPresenter,
	#superclass : #StPresenter,
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#category : #'NewTools-Browser'
}

{ #category : #private }
StBrowserPanelPresenter >> childrenOf: aProjectOrPackage [
	
	aProjectOrPackage ifNil: [ ^ #() ].
	^ aProjectOrPackage browserPackageChildren
]

{ #category : #private }
StBrowserPanelPresenter >> classesOf: aBaselineOrPackageOrTag [
	
	aBaselineOrPackageOrTag ifNil: [ ^ #() ].
	^ aBaselineOrPackageOrTag browserClasses
]
