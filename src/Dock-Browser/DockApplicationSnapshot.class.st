Class {
	#name : 'DockApplicationSnapshot',
	#superclass : 'Object',
	#instVars : [
		'records'
	],
	#category : 'Dock-Browser-Snapshot',
	#package : 'Dock-Browser',
	#tag : 'Snapshot'
}

{ #category : 'initialization' }
DockApplicationSnapshot >> initialize [

	super initialize.
	records := OrderedCollection new
]
