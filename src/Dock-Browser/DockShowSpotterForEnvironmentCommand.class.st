Class {
	#name : 'DockShowSpotterForEnvironmentCommand',
	#superclass : 'PvAction',
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'initialization' }
DockShowSpotterForEnvironmentCommand >> defineAction [

	self name: 'Spotter for Environment'.
	self description: 'Open spotter for the active environment in this perspective'
]

{ #category : 'executing' }
DockShowSpotterForEnvironmentCommand >> execute [
	| spotter |

	spotter := self context
		instantiate: DockSpotter 
		on: (PvSpotterModelForEnvironment 
			newEnvironment: self context model environmentModel 
			origin: self context).
	
	spotter notificationCenter: self context notificationCenter.
			
	spotter openModalWithParent: self context
]
