Class {
	#name : 'PvEditorPathPresenter',
	#superclass : 'SpPresenter',
	#category : 'Perspective-View-Editor',
	#package : 'Perspective',
	#tag : 'View-Editor'
}

{ #category : 'accessing' }
PvEditorPathPresenter >> addSegment: aPresenter [

	self addSeparator.		
	self layout 
		add: aPresenter asPresenter
		expand: false
]

{ #category : 'accessing' }
PvEditorPathPresenter >> addSeparator [
		
	self layout isEmpty ifTrue: [ ^ self ]. 
	self layout 
		add: (self newLabel 
			label: '/';
			yourself)
		expand: false
]

{ #category : 'layout' }
PvEditorPathPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		vAlignCenter;
		spacing: 5;
		yourself
]

{ #category : 'accessing' }
PvEditorPathPresenter >> removeAllSegments [

	self layout removeAll
]
