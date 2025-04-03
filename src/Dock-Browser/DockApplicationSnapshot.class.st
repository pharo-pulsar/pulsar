Class {
	#name : 'DockApplicationSnapshot',
	#superclass : 'DockBaseSnapshot',
	#instVars : [
		'records'
	],
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'testing' }
DockApplicationSnapshot >> hasRecords [

	^ records isNotEmpty
]

{ #category : 'initialization' }
DockApplicationSnapshot >> initialize [

	super initialize.
	records := OrderedCollection new
]

{ #category : 'initialization' }
DockApplicationSnapshot >> restoreTo: anApplication [
	
	records 
		collect: [ :each | self restoreWindow: each to: anApplication  ]
		thenDo: [ :each | each open ]
]

{ #category : 'initialization' }
DockApplicationSnapshot >> restoreWindow: aSnapshot to: anApplication [
	| window |

	window := aSnapshot instantiateOn: anApplication.
	aSnapshot restoreTo: window.
	
	^ window
]

{ #category : 'initialization' }
DockApplicationSnapshot >> snapshot: anApplication [

	records := anApplication windows collect: [ :each | each snapshot ]
]
