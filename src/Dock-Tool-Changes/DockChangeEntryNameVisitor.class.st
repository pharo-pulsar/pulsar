Class {
	#name : 'DockChangeEntryNameVisitor',
	#superclass : 'EpEntryContentVisitor',
	#category : 'Dock-Tool-Changes',
	#package : 'Dock-Tool-Changes'
}

{ #category : 'visitor' }
DockChangeEntryNameVisitor >> visitEvent: aChange [

	^ aChange asString
]
