Class {
	#name : 'DockPackageCritiquesModel',
	#superclass : 'DockCritiquesModel',
	#category : 'Dock-Tool-CritiquesConsole',
	#package : 'Dock-Tool-CritiquesConsole'
}

{ #category : 'private' }
DockPackageCritiquesModel >> collectCritiques [
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
DockPackageCritiquesModel >> isScope: aSymbol [

	^ aSymbol == #package
]

{ #category : 'accessing' }
DockPackageCritiquesModel >> title [

	^ self currentModel
		ifNotNil:[ :aModel | 'Critiques on {1} package' format: { aModel name } ]
		ifNil: [ 'No package selected' ]
]

{ #category : 'visiting' }
DockPackageCritiquesModel >> visitClassModel: aModel [

	^ PvPackageModel 
		newEnvironment: aModel environmentModel 
		entity: aModel package
]

{ #category : 'visiting' }
DockPackageCritiquesModel >> visitMethodModel: aModel [

	^ PvPackageModel 
		newEnvironment: aModel environmentModel 
		entity: aModel package
]

{ #category : 'visiting' }
DockPackageCritiquesModel >> visitPackageModel: aModel [

	^ aModel
]

{ #category : 'visiting' }
DockPackageCritiquesModel >> visitPackageTagModel: aModel [

	^ PvPackageModel 
		newEnvironment: aModel environmentModel 
		entity: aModel package
]
