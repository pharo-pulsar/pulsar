Class {
	#name : #StBaseFeatureTest,
	#superclass : #StBaseBrowserTest,
	#category : #'NewTools-Browser-Tests'
}

{ #category : #testing }
StBaseFeatureTest class >> isAbstract [

	^ super isAbstract or: [ self = StBaseFeatureTest ]
]
