Class {
	#name : 'PulsarApplicationSnapshot',
	#superclass : 'PulsarBaseSnapshot',
	#instVars : [
		'records'
	],
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'testing' }
PulsarApplicationSnapshot >> hasRecords [

	^ records isNotEmpty
]

{ #category : 'initialization' }
PulsarApplicationSnapshot >> initialize [

	super initialize.
	records := OrderedCollection new
]

{ #category : 'initialization' }
PulsarApplicationSnapshot >> restoreTo: anApplication [

	anApplication suspendAnnouncementsDuring: [ 
		(records sorted: #restorePriority ascending)
			collect: [ :each | self restoreWindow: each to: anApplication  ]
			thenDo: [ :each | each open ] ]
]

{ #category : 'initialization' }
PulsarApplicationSnapshot >> restoreWindow: aSnapshot to: anApplication [
	| window |

	window := aSnapshot instantiateOn: anApplication.
	window notificationCenter 
		suspendAllWhile: [ aSnapshot restoreTo: window ].
	
	^ window
]

{ #category : 'initialization' }
PulsarApplicationSnapshot >> snapshot: anApplication [
	"popovers are not snapshoted"
	records := anApplication windows 
		reject: [ :each | each isPopover ]
		thenCollect: [ :each | each snapshot ]
]
