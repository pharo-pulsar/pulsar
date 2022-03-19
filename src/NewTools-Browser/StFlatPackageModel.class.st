Class {
	#name : #StFlatPackageModel,
	#superclass : #StPackageModel,
	#category : #'NewTools-Browser-Model-Package'
}

{ #category : #accessing }
StFlatPackageModel >> children [

	^ self classes, 
	  (StVirtualPackageTagModel newVirtualModelsFor: self package)
]
