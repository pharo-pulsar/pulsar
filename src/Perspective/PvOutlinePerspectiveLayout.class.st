Class {
	#name : #PvOutlinePerspectiveLayout,
	#superclass : #PvTilePerspectiveLayout,
	#category : #'Perspective-View-Perspective'
}

{ #category : #factory }
PvOutlinePerspectiveLayout >> createLayoutOn: aPresenter [
	
	^ SpPanedLayout newLeftToRight 
		positionOfSlider: 25 percent;
		first: (aPresenter newContainer: #overview) useTabLayout;
		second: (SpPanedLayout newTopToBottom
			positionOfSlider: 70 percent;
			first: (SpPanedLayout newLeftToRight
				positionOfSlider: 65 percent;  
				first: (aPresenter newEditorContainer: #edit) useTabLayout; 
				second: (aPresenter newContainer: #outline) useTabLayout;
				yourself);
			second: (aPresenter newContainer: #tools) useTabLayout;
			yourself);
		yourself
]
