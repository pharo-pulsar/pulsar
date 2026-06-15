"
I am the abstract base class for project models in Pulsar. 
I provide common behavior shared by all project types, including close actions, editor configuration, and package creation. My concrete subclasses are PulsarProjectModel (baseline-backed) and PulsarStandaloneProjectModel (free-standing, no baseline).
"
Class {
	#name : 'PulsarBaseProjectModel',
	#superclass : 'PvBaseModel',
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing - actions' }
PulsarBaseProjectModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: 'operations') copyWithContext: aContextPresenter
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> addPackageNamed: aName [

	(self environmentModel hasPackageNamed: aName) ifTrue: [ ^ self ].
	^ self environmentModel addPackageNamed: aName
]

{ #category : 'private - definitions' }
PulsarBaseProjectModel >> defineActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: 'operations' with: [ :group |
			group
				name: 'Operations';
				beDisplayedAsGroup;
				addActionWith: [ :actions |
						actions
							name: ('Close project {1}' format: { self name });
							description: 'Remove project from projects list';
							action: [ :aContext | aContext doCloseProject: self ] ] ]
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> dependencyModels [

	^ #(  )
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> editorClass [

	^ PvProjectEditorView
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> iconName [

	^ self subclassResponsibility
]

{ #category : 'testing' }
PulsarBaseProjectModel >> isManagedAndModified [

	^ false
]

{ #category : 'testing' }
PulsarBaseProjectModel >> isProject [

	^ true
]

{ #category : 'testing' }
PulsarBaseProjectModel >> isVolatileProject [

	^ false
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> pulsarEditorClass [

	^ PulsarProjectEditor
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> repositoryModel [

	^ nil
]
