Extension { #name : 'PvMethodModel' }

{ #category : '*Dock-Browser' }
PvMethodModel >> dockEditorClass [

	^ DockMethodEditor
]

{ #category : '*Dock-Browser' }
PvMethodModel >> isUsingVariable: aVariableModel [

	^ aVariableModel isIncludedIn: self
]
