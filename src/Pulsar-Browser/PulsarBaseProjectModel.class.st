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

	^ (self actions actionsForAll: #(operations tools operationCritical)) copyWithContext: aContextPresenter
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> addPackageNamed: aName [

	(self environmentModel hasPackageNamed: aName) ifTrue: [ ^ self ].
	^ self environmentModel addPackageNamed: aName
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> children [

	self subclassResponsibility
]

{ #category : 'private - definitions' }
PulsarBaseProjectModel >> defineActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #tools with: [ :group | group
		name: 'Tools';
		beDisplayedAsGroup;
		priority: 900;
		addActionWith: [ :action | action
			name: 'Browse in panel';
			iconName: 'project';
			description: 'Open this project in a focused panel';
			action: [ :aContext | 
				aContext notificationCenter announce: (PulsarRequestProjectAnnouncement on: self)  ] ] ]
]

{ #category : 'private - definitions' }
PulsarBaseProjectModel >> defineCriticalActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #operationCritical with: [ :group | group
		name: 'DANGER ZONE';
		priority: 1000;
		beDisplayedAsGroup;
		addActionWith: [ :action | action
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

{ #category : 'updating' }
PulsarBaseProjectModel >> filterWith: aString [

	^ (self environmentModel classesMatching: aString) collect: [ :each |
		  PvClassModel newEnvironment: self environmentModel entity: each ]
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> findPathForClass: aClass [

	^ self findPathForClassModel: (PvClassModel 
		newEnvironment: self environmentModel 
		entity: aClass)
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> findPathForClassModel: aClassModel [
	| path |
	
	path := self
		pathTo: {
			aClassModel packageName.
			aClassModel packageTagName }
		in: self children.
	path ifNotEmpty: [ ^ (path collect: #value) , (self findRecursivelyPathForClassModel: aClassModel inNode: path last key) ].

	^ nil
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> findPathForPackage: aPackage [
	| path |
	
	path := self pathTo: { aPackage name } in: self children.
	path ifNotEmpty: [ ^ path collect: #value ].

	^ nil
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

{ #category : 'instance creation' }
PulsarBaseProjectModel >> newTestRunnerModel [

	^ PulsarTestRunnerModel 
		newEnvironment: self environmentModel 
		entity: self
]

{ #category : 'accessing - navigating' }
PulsarBaseProjectModel >> parentModel [
	"in pulsar metamodel, projects do not have parent"

	^ nil
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> pulsarEditorClass [

	^ PulsarProjectEditor
]

{ #category : 'accessing' }
PulsarBaseProjectModel >> repositoryModel [

	^ nil
]
