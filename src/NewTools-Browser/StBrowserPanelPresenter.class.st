Class {
	#name : #StBrowserPanelPresenter,
	#superclass : #StBrowserModelPresenter,
	#category : #'NewTools-Browser-View'
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
