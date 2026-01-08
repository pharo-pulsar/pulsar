"
How the dock windows work right now (and we are not changing it immediately), when we place a window in a top or bottom panel, they use a sidebar tab to show it.  
This is of course not very nice if we have a title to show, e.g. ""Playground"", because it will take a lot of place. In this case, libpanel (the underlying library we use) chooses to show an icon if we define an icon.  
But (at least for now) I do not want to show an icon in the lateral panels (there we can show a title, I think).  
So for now I am introducing this behavior, to switch between ""icon"" and ""title"" depending on the area context.  
"
Trait {
	#name : 'PulsarTPanelWindowWithPlacedIcon',
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
PulsarTPanelWindowWithPlacedIcon >> panelPlaced: aPanelWidgetPresenter [
	| inHorizontalArea iconName |
	iconName := self panelPlacedIconName.
	iconName ifNil: [ ^ self ].
		
	inHorizontalArea := { SpPanelArea top. SpPanelArea bottom } includes: aPanelWidgetPresenter panelPosition area.
	aPanelWidgetPresenter windowIcon: (inHorizontalArea
		ifTrue: [ self iconNamed: iconName ]
		ifFalse: [ nil ])
]

{ #category : 'private' }
PulsarTPanelWindowWithPlacedIcon >> panelPlacedIconName [

	^ nil 
]
