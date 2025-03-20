Extension { #name : 'PvMethodModel' }

{ #category : '*Dock-Browser' }
PvMethodModel >> dockEditorClass [

	^ DockMethodEditor
]

{ #category : '*Dock-Browser' }
PvMethodModel >> isUsingAnyVariable: aCollection [

	^ aCollection anySatisfy: [ :each |
			self isUsingVariable: each ]
]

{ #category : '*Dock-Browser' }
PvMethodModel >> isUsingVariable: aVariableModel [

	^ aVariableModel isIncludedIn: self
]
