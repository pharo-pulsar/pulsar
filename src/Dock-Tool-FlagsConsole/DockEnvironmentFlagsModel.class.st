Class {
	#name : 'DockEnvironmentFlagsModel',
	#superclass : 'DockFlagsModel',
	#category : 'Dock-Tool-FlagsConsole',
	#package : 'Dock-Tool-FlagsConsole'
}

{ #category : 'private' }
DockEnvironmentFlagsModel >> calculateEnvironment [
	
	"itself"
	^ self environmentModel
]

{ #category : 'accessing' }
DockEnvironmentFlagsModel >> title [

	^ 'Flags on Environment'
]
