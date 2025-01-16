Class {
	#name : 'DockBreadcrumbPresenter',
	#superclass : 'PvEditorPathPresenter',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'defaults' }
DockBreadcrumbPresenter class >> defaultSeparatorString [
	"U+232A = 〉 (it looks nice for the breadcrumb)"
	
	^ (Character value: 16r232A) asString 
]

{ #category : 'layout' }
DockBreadcrumbPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		vAlignCenter;
		hAlignStart;
		yourself		
]

{ #category : 'initialization' }
DockBreadcrumbPresenter >> initializePresenters [

	super initializePresenters. 
	self addStyle: 'dockEditorBreadcrumb'
]

{ #category : 'accessing' }
DockBreadcrumbPresenter >> segments [

	^ self layout children
]

{ #category : 'updating' }
DockBreadcrumbPresenter >> updateBreadcrumbWith: aBlock [ 

	self application defer: [
		self removeAllSegments.
		aBlock value: self ]
]
