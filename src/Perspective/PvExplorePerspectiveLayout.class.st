Class {
	#name : 'PvExplorePerspectiveLayout',
	#superclass : 'PvTilePerspectiveLayout',
	#category : 'Perspective-View-Perspective',
	#package : 'Perspective',
	#tag : 'View-Perspective'
}

{ #category : 'factory' }
PvExplorePerspectiveLayout >> createLayoutOn: aPresenter [
	
	^ SpPanedLayout newLeftToRight 
		positionOfSlider: 25 percent;
		first: (aPresenter newContainer: #overview) useVerticalLayout;
		second: (SpPanedLayout newTopToBottom
			positionOfSlider: 50 percent;
			first: (aPresenter newEditorContainer: #edit) useTabLayout;
			second: (aPresenter newContainer: #tools) useTabLayout;
			yourself);
		yourself
]
