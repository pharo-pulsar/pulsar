Class {
	#name : 'PvFlatPackageModel',
	#superclass : 'PvPackageModel',
	#category : 'Perspective-Package-Model',
	#package : 'Perspective-Package',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvFlatPackageModel >> children [

	^ self classes", 
	  (StVirtualPackageTagModel newVirtualModelsFor: self package)"
]
