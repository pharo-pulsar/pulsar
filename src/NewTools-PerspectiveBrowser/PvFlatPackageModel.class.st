Class {
	#name : #PvFlatPackageModel,
	#superclass : #PvPackageModel,
	#category : #'NewTools-PerspectiveBrowser-Model'
}

{ #category : #accessing }
PvFlatPackageModel >> children [

	^ self classes", 
	  (StVirtualPackageTagModel newVirtualModelsFor: self package)"
]
