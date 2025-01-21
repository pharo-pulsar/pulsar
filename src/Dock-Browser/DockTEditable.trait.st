Trait {
	#name : 'DockTEditable',
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
DockTEditable >> dockEditorClass [

	^ self required
]

{ #category : 'testing' }
DockTEditable >> hasDockEditor [

	^ self dockEditorClass isNotNil
]
