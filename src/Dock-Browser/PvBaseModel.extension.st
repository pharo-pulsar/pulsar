Extension { #name : 'PvBaseModel' }

{ #category : '*Dock-Browser' }
PvBaseModel >> hasDockEditor [

	^ self dockEditorClass isNotNil
]
