Class {
	#name : #PvTilePerspectiveLayout,
	#superclass : #LnTileLayout,
	#category : #'Perspective-View-Perspective'
}

{ #category : #factory }
PvTilePerspectiveLayout >> createLayout [

	self error: 'Should not arrive here'
]

{ #category : #factory }
PvTilePerspectiveLayout >> createLayoutOn: aPresenter [

	self subclassResponsibility
]

{ #category : #'accessing - focus' }
PvTilePerspectiveLayout >> focusDown: aContainer [

	self 
		focusAfter: aContainer
		ifLast: [ aContainer owner focusDown ]
]

{ #category : #'accessing - focus' }
PvTilePerspectiveLayout >> focusLeft: aContainer [

	self focusUp: aContainer
]

{ #category : #'accessing - focus' }
PvTilePerspectiveLayout >> focusRight: aContainer [

	self focusDown: aContainer
]

{ #category : #'accessing - focus' }
PvTilePerspectiveLayout >> focusUp: aContainer [

	self 
		focusBefore: aContainer
		ifFirst: [ aContainer owner focusUp ]
]

{ #category : #private }
PvTilePerspectiveLayout >> layoutActivatedClass [

	^ PvPerspectiveLayoutActivated
]

{ #category : #initialization }
PvTilePerspectiveLayout >> setContentLayoutTo: aPresenter [
	
	aPresenter contentLayout: (self createLayoutOn: aPresenter)
]
