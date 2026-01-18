Class {
	#name : 'PulsarBreadcrumbPresenter',
	#superclass : 'PvEditorPathPresenter',
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'defaults' }
PulsarBreadcrumbPresenter class >> defaultSeparatorString [
	"U+232A = 〉 (it looks nice for the breadcrumb)"
	
	^ (Character value: 16r232A) asString 
]

{ #category : 'layout' }
PulsarBreadcrumbPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		vAlignCenter;
		hAlignStart;
		yourself		
]

{ #category : 'initialization' }
PulsarBreadcrumbPresenter >> initializePresenters [

	super initializePresenters. 
	self addStyle: 'pulsarEditorBreadcrumb'
]

{ #category : 'accessing' }
PulsarBreadcrumbPresenter >> segments [

	^ self layout children
]

{ #category : 'updating' }
PulsarBreadcrumbPresenter >> updateBreadcrumbWith: aBlock [ 

	self application defer: [
		self removeAllSegments.
		aBlock value: self ]
]
