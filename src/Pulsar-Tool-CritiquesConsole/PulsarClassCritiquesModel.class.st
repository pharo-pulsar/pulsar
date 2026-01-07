Class {
	#name : 'PulsarClassCritiquesModel',
	#superclass : 'PulsarCritiquesModel',
	#category : 'Pulsar-Tool-CritiquesConsole',
	#package : 'Pulsar-Tool-CritiquesConsole'
}

{ #category : 'testing' }
PulsarClassCritiquesModel class >> isDefault [

	^ true
]

{ #category : 'private' }
PulsarClassCritiquesModel >> collectCritiques [
	| rules checker |
	
	self currentModel ifNil: [ ^ #() ].

	rules := self rules.	
	checker := ReSmalllintChecker new.
	checker classRules: rules.
	checker checkClass: self currentModel entity.
	^ checker critiques sorted: [ :each | each rule ruleName ] ascending
]

{ #category : 'testing' }
PulsarClassCritiquesModel >> isScope: aSymbol [

	^ aSymbol == #class
]

{ #category : 'accessing' }
PulsarClassCritiquesModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Critiques on {1} class' format: { aModel name } ]
		ifNil: [ 'No class selected' ]
]

{ #category : 'visiting' }
PulsarClassCritiquesModel >> visitClassModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
PulsarClassCritiquesModel >> visitMethodModel: aModel [

	^ aModel asClassModel
]
