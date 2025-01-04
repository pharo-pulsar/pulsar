Class {
	#name : 'DockSystemNavigation',
	#superclass : 'SystemNavigation',
	#instVars : [
		'window'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'instance creation' }
DockSystemNavigation class >> newWindow: aDockWindow [


	^ self new 
		window: aDockWindow;
		yourself
]

{ #category : 'accessing' }
DockSystemNavigation >> application [

	^ self window application
]

{ #category : 'opening' }
DockSystemNavigation >> browse: anObject [
	| modelClass |

	self flag: #TODO. "What happens if this is a trait? Should I use a double dispatch?"
	modelClass := anObject isCompiledMethod 
		ifTrue: [ PvMethodModel ]
		ifFalse: [ PvClassModel ].

	self window announce: (DockModelActivated newValue: (modelClass 
			newEnvironment: self window model environmentModel 
			entity: anObject))
]

{ #category : 'accessing' }
DockSystemNavigation >> window [

	^ window
]

{ #category : 'accessing' }
DockSystemNavigation >> window: aWindow [

	window := aWindow
]
