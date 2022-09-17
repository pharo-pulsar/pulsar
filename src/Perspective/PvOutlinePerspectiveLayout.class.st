Class {
	#name : #PvOutlinePerspectiveLayout,
	#superclass : #PvTilePerspectiveLayout,
	#category : #'Perspective-View-Perspective'
}

{ #category : #factory }
PvOutlinePerspectiveLayout >> createLayoutOn: aPresenter [
	
	^ SpPanedLayout newLeftToRight 
		positionOfSlider: 25 percent;
		add: (aPresenter newContainer: #overview) useTabLayout;
		add: (SpPanedLayout newTopToBottom
			positionOfSlider: 55 percent;
			add: (SpPanedLayout newLeftToRight
				positionOfSlider: 65 percent;  
				add: (aPresenter newEditorContainer: #edit) useTabLayout; 
				add: (aPresenter newContainer: #outline) useTabLayout;
				yourself);
			add: (aPresenter newContainer: #tools) useTabLayout;
			yourself);
		yourself
]
