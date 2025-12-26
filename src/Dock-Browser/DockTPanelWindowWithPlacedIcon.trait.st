Trait {
	#name : 'DockTPanelWindowWithPlacedIcon',
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'private' }
DockTPanelWindowWithPlacedIcon >> panelPlaced: aPanelWidgetPresenter [
	| inHorizontalArea iconName |

	iconName := self panelPlacedIconName.
	iconName ifNil: [ ^ self ].
	
	inHorizontalArea := { SpPanelArea top. SpPanelArea bottom } includes: aPanelWidgetPresenter dockPosition area.
	aPanelWidgetPresenter windowIcon: (inHorizontalArea
		ifTrue: [ self iconNamed: iconName ]
		ifFalse: [ nil ])
]

{ #category : 'private' }
DockTPanelWindowWithPlacedIcon >> panelPlacedIconName [

	^ nil 
]
