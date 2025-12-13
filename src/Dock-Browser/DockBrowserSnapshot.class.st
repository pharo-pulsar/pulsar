Class {
	#name : 'DockBrowserSnapshot',
	#superclass : 'DockBaseBrowserSnapshot',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing' }
DockBrowserSnapshot >> browserClass [

	^ DockBrowser
]

{ #category : 'accessing' }
DockBrowserSnapshot >> restorePriority [
	"restore first"
	
^ 1
]
