Class {
	#name : 'DockShowSpotterForWindowsCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockShowSpotterForWindowsCommand >> defineAction [

	self name: 'Spotter for Windows'.
	self description: 'Open spotter for perspective windows'
]

{ #category : 'execution' }
DockShowSpotterForWindowsCommand >> execute [
	| spotter |
	
	spotter := self context
		instantiate: PvSpotter 
		on: (PvSpotterModelForWindows newOrigin: self context).
	spotter perspective: self context.
	
	spotter asModalWindow
		centeredRelativeTo: self context window;
		open	
]
