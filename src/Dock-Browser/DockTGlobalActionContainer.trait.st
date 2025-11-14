Trait {
	#name : 'DockTGlobalActionContainer',
	#instVars : [
		'globalActions'
	],
	#category : 'Dock-Browser-Actions',
	#package : 'Dock-Browser',
	#tag : 'Actions'
}

{ #category : 'private' }
DockTGlobalActionContainer >> globalActions [

	^ globalActions ifNil: [ globalActions := DockActionCollector collectFor: self ]
]
