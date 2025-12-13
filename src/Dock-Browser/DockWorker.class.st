Class {
	#name : 'DockWorker',
	#superclass : 'TKTWorker',
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
DockWorker >> inTool: aClass [

	^ self name: ('{TOOL}-{ID}' format: {#TOOL -> aClass name. #ID -> UUID new} asDictionary)
]
