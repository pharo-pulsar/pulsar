Class {
	#name : 'DockPlaygroundModel',
	#superclass : 'Object',
	#instVars : [
		'page'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'accessing' }
DockPlaygroundModel >> contents [

	^ page contents
]

{ #category : 'accessing' }
DockPlaygroundModel >> contents: aString [

	page contents: aString
]

{ #category : 'initialization' }
DockPlaygroundModel >> initialize [

	super initialize.
	page := StPlaygroundPage new
]

{ #category : 'accessing' }
DockPlaygroundModel >> loadPage: aPage [

	page := aPage
]

{ #category : 'instance creation' }
DockPlaygroundModel >> newVersionsModel [

	^ DockPlaygroundVersionsModel newPage: page
]
