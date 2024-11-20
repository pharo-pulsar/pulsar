Extension { #name : 'PvBaseModel' }

{ #category : '*Dock-Browser' }
PvBaseModel >> dockEditorClass [

	^ self editorClass
]

{ #category : '*Dock-Browser' }
PvBaseModel >> hasDockEditor [

	^ self dockEditorClass isNotNil
]
