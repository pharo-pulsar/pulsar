Class {
	#name : 'DockPlaygroundVersionsModel',
	#superclass : 'Object',
	#instVars : [
		'page'
	],
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'instance creation' }
DockPlaygroundVersionsModel class >> newPage: aPage [

	^ self new
		page: aPage;
		yourself
]

{ #category : 'accessing' }
DockPlaygroundVersionsModel >> page [

	^ page
]

{ #category : 'accessing' }
DockPlaygroundVersionsModel >> page: aPage [

	page := aPage
]

{ #category : 'accessing' }
DockPlaygroundVersionsModel >> title [

	^ 'Page versions'
]

{ #category : 'accessing' }
DockPlaygroundVersionsModel >> versions [

	^ self page versions reversed
]
