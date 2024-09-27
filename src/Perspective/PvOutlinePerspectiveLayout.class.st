Class {
	#name : 'PvOutlinePerspectiveLayout',
	#superclass : 'PvTilePerspectiveLayout',
	#category : 'Perspective-View-Perspective',
	#package : 'Perspective',
	#tag : 'View-Perspective'
}

{ #category : 'factory' }
PvOutlinePerspectiveLayout >> createLayoutOn: aPresenter [
	| extent |
	
	extent := aPresenter initialExtent.
	"assuming starting window is"
	^ SpPanedLayout newHorizontal 
		positionOfSlider: (extent x * 0.25) asInteger;
		add: (aPresenter newContainer: #overview) useTabLayout;
		add: (SpPanedLayout newVertical
			positionOfSlider: (extent y * 0.6) asInteger;
			add: (SpPanedLayout newHorizontal
				positionOfSlider: extent x * 0.5;
				add: (aPresenter newEditorContainer: #edit) useTabLayout; 
				add: (aPresenter newContainer: #outline) useTabLayout;
				yourself);
			add: (aPresenter newContainer: #tools) useTabLayout;
			yourself);
		yourself
]
