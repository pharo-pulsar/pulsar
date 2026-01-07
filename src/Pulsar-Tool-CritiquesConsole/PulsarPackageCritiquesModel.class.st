Class {
	#name : 'PulsarPackageCritiquesModel',
	#superclass : 'PulsarCritiquesModel',
	#category : 'Pulsar-Tool-CritiquesConsole',
	#package : 'Pulsar-Tool-CritiquesConsole'
}

{ #category : 'private' }
PulsarPackageCritiquesModel >> collectCritiques [
	| rules env checker |

	rules := self rules.
	env := RBPackageEnvironment packageName: currentModel name.
	checker := ReSmalllintChecker new.

	checker classRules: rules.

	env classes do: [ :each |
		checker checkClass: each ].
	
	checker rule: rules.	

	^ checker critiques.
]

{ #category : 'testing' }
PulsarPackageCritiquesModel >> isScope: aSymbol [

	^ aSymbol == #package
]

{ #category : 'accessing' }
PulsarPackageCritiquesModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Critiques on {1} package' format: { aModel name } ]
		ifNil: [ 'No package selected' ]
]

{ #category : 'visiting' }
PulsarPackageCritiquesModel >> visitClassModel: aModel [

	^ PvPackageModel 
		newEnvironment: aModel environmentModel 
		entity: aModel package
]

{ #category : 'visiting' }
PulsarPackageCritiquesModel >> visitMethodModel: aModel [

	^ PvPackageModel 
		newEnvironment: aModel environmentModel 
		entity: aModel package
]

{ #category : 'visiting' }
PulsarPackageCritiquesModel >> visitPackageModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
PulsarPackageCritiquesModel >> visitPackageTagModel: aModel [

	^ PvPackageModel 
		newEnvironment: aModel environmentModel 
		entity: aModel package
]
