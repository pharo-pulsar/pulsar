Class {
	#name : 'PvShowSpotterForEnvironmentAction',
	#superclass : 'PvAction',
	#category : 'Perspective-Command-Actions',
	#package : 'Perspective',
	#tag : 'Command-Actions'
}

{ #category : 'initialization' }
PvShowSpotterForEnvironmentAction >> defineAction [

	self name: 'Spotter for Environment'.
	self description: 'Open spotter for the active environment in this perspective'
]

{ #category : 'executing' }
PvShowSpotterForEnvironmentAction >> execute [
	| spotter |

	spotter := self context
		instantiate: PvSpotter 
		on: (PvSpotterModelForEnvironment newOrigin: self context).
	spotter perspective: self context.
	
	spotter asModalWindow
		centeredRelativeTo: self context window;
		open
]
