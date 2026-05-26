"
I am a saved arrangement of panel positions for a Pulsar browser type (e.g. `PulsarBrowser`, `PulsarDebugger`).

Each browser type class holds an ordered collection of my instances in its `#browserPanelLayouts` class slot. The first layout is always the default layout.

I map view classes to their last-used SpPanelPosition. When a user drags a non-editor panel to a new location, the position is saved through me. Next time that view class is opened, it appears at the remembered position instead of the class default.

Instance Variables:
  name:  An optional String that names this layout. nil means it is the default layout.
  positions:  An IdentityDictionary mapping view classes (key) to SpPanelPosition instances (value). Lazy initialized.

My `isDefault` method returns true when name is nil.
"
Class {
	#name : 'PulsarBrowserPanelLayout',
	#superclass : 'Object',
	#instVars : [
		'name',
		'positions'
	],
	#category : 'Pulsar-Browser',
	#package : 'Pulsar-Browser'
}

{ #category : 'testing' }
PulsarBrowserPanelLayout >> isDefault [

	^ name isNil
]

{ #category : 'accessing' }
PulsarBrowserPanelLayout >> name [

	^ name
]

{ #category : 'accessing' }
PulsarBrowserPanelLayout >> name: aString [

	name := aString
]

{ #category : 'accessing' }
PulsarBrowserPanelLayout >> positions [

	^ positions ifNil: [ positions := IdentityDictionary new ]
]

{ #category : 'panel positions' }
PulsarBrowserPanelLayout >> savePanelPosition: aSpPanelPosition forViewClass: aClass [

	self positions 
		at: aClass 
		put: aSpPanelPosition
]

{ #category : 'panel positions' }
PulsarBrowserPanelLayout >> savedPositionForViewClass: aClass ifAbsent: absentBlock [

	(aClass includesBehavior: PulsarEditor) 
		ifTrue: [ ^ absentBlock value ].
		
	^ self positions at: aClass ifAbsent: absentBlock
]
