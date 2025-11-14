Trait {
	#name : 'DockTGlobalActionContainer',
	#instVars : [
		'globalActions'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'private' }
DockTGlobalActionContainer >> globalActions [

	^ globalActions ifNil: [ globalActions := DockActionCollector collectFor: self ]
]
