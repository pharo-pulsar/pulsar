Extension { #name : 'PvBaseModel' }

{ #category : '*Dock-Browser' }
PvBaseModel >> dockEditorClass [

	^ self editorClass
]

{ #category : '*Dock-Browser' }
PvBaseModel >> hasDockEditor [

	^ self dockEditorClass isNotNil
]

{ #category : '*Dock-Browser' }
PvBaseModel >> realModel [

	^ self
]
