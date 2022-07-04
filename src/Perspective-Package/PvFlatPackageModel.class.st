Class {
	#name : #PvFlatPackageModel,
	#superclass : #PvPackageModel,
	#category : #'Perspective-Package-Model'
}

{ #category : #accessing }
PvFlatPackageModel >> children [

	^ self classes", 
	  (StVirtualPackageTagModel newVirtualModelsFor: self package)"
]
