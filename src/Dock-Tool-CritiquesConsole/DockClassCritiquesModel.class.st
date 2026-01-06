Class {
	#name : 'DockClassCritiquesModel',
	#superclass : 'DockCritiquesModel',
	#category : 'Dock-Tool-CritiquesConsole',
	#package : 'Dock-Tool-CritiquesConsole'
}

{ #category : 'testing' }
DockClassCritiquesModel class >> isDefault [

	^ true
]

{ #category : 'private' }
DockClassCritiquesModel >> collectCritiques [
	| rules checker |
	
	self currentModel ifNil: [ ^ #() ].

	rules := self rules.	
	checker := ReSmalllintChecker new.
	checker classRules: rules.
	checker checkClass: self currentModel entity.
	^ checker critiques sorted: [ :each | each rule ruleName ] ascending
]

{ #category : 'testing' }
DockClassCritiquesModel >> isScope: aSymbol [

	^ aSymbol == #class
]

{ #category : 'accessing' }
DockClassCritiquesModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Critiques on {1} class' format: { aModel name } ]
		ifNil: [ 'No class selected' ]
]

{ #category : 'visiting' }
DockClassCritiquesModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
DockClassCritiquesModel >> visitMethodModel: aModel [

	^ aModel asClassModel
]
