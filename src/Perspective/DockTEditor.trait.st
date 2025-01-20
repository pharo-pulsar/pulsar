Trait {
	#name : 'DockTEditor',
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
DockTEditor >> dockEditorClass [

	^ self required
]

{ #category : 'testing' }
DockTEditor >> hasDockEditor [

	^ self dockEditorClass isNotNil
]
