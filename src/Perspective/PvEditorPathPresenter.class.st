Class {
	#name : 'PvEditorPathPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'separatorString'
	],
	#category : 'Perspective-View-Editor',
	#package : 'Perspective',
	#tag : 'View-Editor'
}

{ #category : 'defaults' }
PvEditorPathPresenter class >> defaultSeparatorString [

	^ '/'
]

{ #category : 'accessing' }
PvEditorPathPresenter >> addLinkSegment: aString action: aBlock [ 

	self addSegment: (self newLink 
		label: aString;
		action: aBlock;
		yourself)
]

{ #category : 'accessing' }
PvEditorPathPresenter >> addSegment: aPresenter [

	self addSeparator.		
	self layout add: aPresenter asPresenter
]

{ #category : 'accessing' }
PvEditorPathPresenter >> addSeparator [
		
	self layout isEmpty ifTrue: [ ^ self ]. 
	self layout add: self newSeparator
]

{ #category : 'layout' }
PvEditorPathPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		vAlignCenter;
		hAlignStart;
		yourself
]

{ #category : 'instance creation' }
PvEditorPathPresenter >> newSeparator [

	^ self newLabel 
		addStyle: 'separator';
		label: self separatorString;
		yourself
]

{ #category : 'accessing' }
PvEditorPathPresenter >> removeAllSegments [

	self layout removeAll
]

{ #category : 'accessing' }
PvEditorPathPresenter >> separatorString [

	^ separatorString ifNil: [ separatorString := self class defaultSeparatorString ]
]

{ #category : 'accessing' }
PvEditorPathPresenter >> separatorString: aString [

	separatorString := aString
]
