Trait {
	#name : 'DockTActionHolder',
	#instVars : [
		'actions'
	],
	#category : 'Dock-Browser-Application ',
	#package : 'Dock-Browser',
	#tag : 'Application '
}

{ #category : 'accessing' }
DockTActionHolder >> actions [

	^ actions ifNil: [ actions := DockActionCollector collectFor: self ]
]
