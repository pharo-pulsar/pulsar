Class {
	#name : 'PvShowSpotterForWindowsAction',
	#superclass : 'PvAction',
	#category : 'Perspective-Command-Actions',
	#package : 'Perspective',
	#tag : 'Command-Actions'
}

{ #category : 'initialization' }
PvShowSpotterForWindowsAction >> defineAction [

	self name: 'Spotter for Windows'.
	self description: 'Open spotter for perspective windows'
]

{ #category : 'execution' }
PvShowSpotterForWindowsAction >> execute [
	| spotter |
	
	spotter := self context
		instantiate: PvSpotter 
		on: (PvSpotterModelForWindows newOrigin: self context).
	spotter perspective: self context.
	
	spotter asModalWindow
		centeredRelativeTo: self context window;
		open	
]
