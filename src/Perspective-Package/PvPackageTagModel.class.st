Class {
	#name : 'PvPackageTagModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Package-Model',
	#package : 'Perspective-Package',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvPackageTagModel class >> order [

	^ 100
]

{ #category : 'visiting' }
PvPackageTagModel >> accept: aVisitor [

	^ aVisitor visitPackageTagModel: self
]

{ #category : 'accessing - actions' }
PvPackageTagModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: #refactors) 
		copyWithContext: (PulsarRefactorPackageContext on: aContextPresenter)
]

{ #category : 'converting' }
PvPackageTagModel >> asPackageModel [

	^ PvPackageModel 
		newEnvironment: self environmentModel
		entity: self package
]

{ #category : 'accessing' }
PvPackageTagModel >> children [

	^ PvClassHierarchyBuilder buildFrom: self classes
]

{ #category : 'accessing' }
PvPackageTagModel >> classDefinitionString [
	
	^ PvFluidClassDefinitionPrinter new 
		classDefinitionTemplateInPackage: self package name
		tag: (self entity isRoot 
			ifTrue: [ nil ]
			ifFalse: [ self name ])
]

{ #category : 'accessing' }
PvPackageTagModel >> classes [

	^ (self entity classes
		collect: [ :each | 
			PvClassModel 
				newEnvironment: self environmentModel 
				parent: self
				entity: each ]
		as: OrderedCollection)
		sorted: #name ascending
]

{ #category : 'private - definitions' }
PvPackageTagModel >> defineRefactorActionsOn: aBuilder [
	<dockActions>
	
	"this actions cannot be used directly in this context (the model 
	 context), because execute them require interact with the UI"
	aBuilder addGroup: #refactors with: [ :group | group
		name: 'Refactors';
		beDisplayedAsGroup;
		addActionWith: [ :action | action
			name: ('Rename {1}' format: { self name });
			description: 'Rename package tag';
			action: [ :aContext | aContext doRenamePackageTag: self ] ] ]
]

{ #category : 'accessing' }
PvPackageTagModel >> iconName [

	^ nil "'tag'"
]

{ #category : 'testing' }
PvPackageTagModel >> isManagedAndModified [

	^ self parentModels 
		detect: [ :each | each isProject ]
		ifFound: [ :aProjectModel | 
			"aProjectModel repositoryModel isPackageModified: self entity"
			aProjectModel isManagedAndModified ]
		ifNone: [ false ]
]

{ #category : 'testing' }
PvPackageTagModel >> isPackageTag [

	^ true
]

{ #category : 'testing' }
PvPackageTagModel >> isRoot [

	^ self entity isRoot
]

{ #category : 'accessing' }
PvPackageTagModel >> name [

	^ self entity name
]

{ #category : 'accessing' }
PvPackageTagModel >> order [

	^ self class order
]

{ #category : 'accessing' }
PvPackageTagModel >> package [

	^ self entity package
]

{ #category : 'actions' }
PvPackageTagModel >> renameTo: aNewName [

	self entity renameTo: aNewName
]

{ #category : 'accessing' }
PvPackageTagModel >> traitDefinitionString [
	
	^ PvFluidClassDefinitionPrinter new 
		traitDefinitionTemplateInPackage: self package name
		tag: (self entity isRoot 
			ifTrue: [ nil ]
			ifFalse: [ self name ])
]
