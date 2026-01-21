Class {
	#name : 'PvPackageModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'projectModel'
	],
	#category : 'Perspective-Package-Model',
	#package : 'Perspective-Package',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvPackageModel class >> newEnvironment: anEnvironmentModel project: projectModel entity: anObject [

	^ (super newEnvironment: anEnvironmentModel entity: anObject)
		project: projectModel;
		yourself
]

{ #category : 'accessing - actions' }
PvPackageModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: 'refactors') 
		copyWithContext: (PulsarRefactorPackageContext on: aContextPresenter)
]

{ #category : 'accessing' }
PvPackageModel >> addPackageTagNamed: aString [

	self entity ensureTag: aString
]

{ #category : 'accessing' }
PvPackageModel >> children [

	^ (((self entity tags
		reject: [ :each | each name = self name ]) 
		collect: [ :each | PvPackageTagModel newEnvironment: self environmentModel entity: each ]
		as: OrderedCollection)
		addAll: ((PvVirtualPackageTagModel 
			virtualModelsFor: self entity)
			collect: [ :each | 
				each 
					newEnvironment: self environmentModel 
					parent: self
					entity: self entity ]);
		sorted: #order ascending, #name ascending)
		yourself
]

{ #category : 'helpers' }
PvPackageModel >> classDefinitionString [
	
	^ PvFluidClassDefinitionPrinter new 
		classDefinitionTemplateInPackage: self name
		tag: nil
]

{ #category : 'accessing' }
PvPackageModel >> classes [

	^ self entity definedClasses
		collect: [ :each | PvClassModel newEnvironment: self environmentModel entity: each ]
		as: OrderedCollection
]

{ #category : 'private - definitions' }
PvPackageModel >> defineRefactorActionsOn: aBuilder [
	<dockActions>
	
	"this actions cannot be used directly in this context (the model 
	 context), because execute them require interact with the UI"
	aBuilder addGroup: #refactors with: [ :group | group
		name: 'Refactors';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			name: ('Rename {1}' format: { self name });
			description: 'Rename package';
			action: [ :aContext | aContext doRenamePackage: self ] ] ]
]

{ #category : 'accessing' }
PvPackageModel >> iconName [

	^ #package
	
]

{ #category : 'testing' }
PvPackageModel >> isManagedAndModified [

	^ self parentModels 
		detect: [ :each | each isProject ]
		ifFound: [ :aProjectModel | 
			"aProjectModel repositoryModel isPackageModified: self entity"
			aProjectModel isManagedAndModified ]
		ifNone: [ false ]
]

{ #category : 'testing' }
PvPackageModel >> isPackage [

	^ true
]

{ #category : 'accessing' }
PvPackageModel >> name [

	^ self entity name
]

{ #category : 'accessing' }
PvPackageModel >> package [

	^ self entity
]

{ #category : 'accessing' }
PvPackageModel >> project [

	^ projectModel
]

{ #category : 'accessing' }
PvPackageModel >> project: aProjectModel [

	projectModel := aProjectModel
]

{ #category : 'actions' }
PvPackageModel >> renameTo: aNewName [

	self entity renameTo: aNewName
]

{ #category : 'helpers' }
PvPackageModel >> traitDefinitionString [
	
	^ PvFluidClassDefinitionPrinter new 
		traitDefinitionTemplateInPackage: self name
		tag: nil
]
