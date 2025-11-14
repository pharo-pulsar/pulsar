Trait {
	#name : 'DockTActionContainer',
	#instVars : [
		'actions'
	],
	#category : 'Dock-Browser-Actions',
	#package : 'Dock-Browser',
	#tag : 'Actions'
}

{ #category : 'private' }
DockTActionContainer >> actions [

	^ actions ifNil: [ actions := DockActionCollector collectFor: self ]
]
