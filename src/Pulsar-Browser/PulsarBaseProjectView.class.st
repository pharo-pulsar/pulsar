"
Abstract base class for project tree views in Pulsar. Provides shared tree navigation, filtering, event handling, and action infrastructure for both multi-project (PulsarProjectView) and single-project (PulsarSingleProjectView) views.

Subclasses define how roots are computed (allChildren vs children) and which project-level actions are available.
"
Class {
	#name : 'PulsarBaseProjectView',
	#superclass : 'PulsarBaseView',
	#instVars : [
		'toolbarPresenter',
		'mutex',
		'filterInputPresenter',
		'filterListPresenter',
		'listPresenter'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'events' }
PulsarBaseProjectView >> activateContextPopover [

	
]

{ #category : 'selection' }
PulsarBaseProjectView >> canRemoveSelectedEntity [

	^ self selectedEntity ifNotNil: [ :anEntityModel | anEntityModel canBeRemoved ] ifNil: [ false ]
]

{ #category : 'selection' }
PulsarBaseProjectView >> canRenameSelectedEntity [

	^ self selectedEntity ifNotNil: [ :anEntityModel | anEntityModel canBeRenamed ] ifNil: [ false ]
]

{ #category : 'selection' }
PulsarBaseProjectView >> closestEntityInPathMatching: aBlock [

	^ self selectedEntitiesInPath ifNotEmpty: [ :entities | entities reversed detect: aBlock ] ifEmpty: [ nil ]
]

{ #category : 'selection' }
PulsarBaseProjectView >> closestPathInPathMatching: aBlock [

	  | selectedEntities |
	  selectedEntities := self selectedEntitiesInPath.
	  selectedEntities ifNil: [ ^ nil ].

	  selectedEntities withIndexDo: [ :each :index | (aBlock value: each) ifTrue: [ ^ selectedEntities copyFrom: 1 to: index ] ].

	  ^ nil
]

{ #category : 'initialization' }
PulsarBaseProjectView >> connectPresenters [

	super connectPresenters.

	listPresenter outputSelectionPort transmitDo: [ :anEntity | self entitySelected: anEntity ].
	listPresenter outputActivationPort transmitDo: [ :anEntity | self entityActivated: anEntity ].

	filterListPresenter outputSelectionPort transmitDo: [ :anEntity | self entitySelected: anEntity ].
	filterListPresenter outputActivationPort transmitDo: [ :anEntity | self entityActivated: anEntity ].
	filterInputPresenter whenTextChangedDo: [ :aString | self updateFilterWith: aString ]
]

{ #category : 'events' }
PulsarBaseProjectView >> deactivateContextPopover [

	
]

{ #category : 'layout' }
PulsarBaseProjectView >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPresenter expand: false;
		  add: listPresenter;
		  add: filterListPresenter;
		  add: filterInputPresenter expand: false;
		  yourself
]

{ #category : 'actions-definition' }
PulsarBaseProjectView >> defineExtraActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: 'extra' with: [ :group |
			group
				priority: 900;
				name: 'Extra';
				beDisplayedAsGroup;
				addActionWith: [ :action |
						action
							name: 'Collapse All';
							description: 'Collapses all open nodes';
							iconName: 'collapse-all';
							action: [ self doCollapseAll ] ] ]
]

{ #category : 'actions-definition' }
PulsarBaseProjectView >> defineNewActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #new with: [ :group |
			group
				priority: 200;
				name: 'New';
				beDisplayedAsGroup;
				addActionWith: [ :action |
						action
							priority: 210;
							name: 'New package';
							description: 'Add a new package';
							iconName: 'new-file';
							action: [ self doNewPackage ] ];
				addActionWith: [ :action |
						action
							priority: 220;
							name: 'New tag';
							description: 'Add a new tag to this package';
							iconName: 'new-file';
							action: [ self doNewPackageTag ] ];
				addActionWith: [ :action |
						action
							priority: 230;
							name: 'New class';
							description: 'Add a new class';
							iconName: 'new-file';
							action: [ self doRequestNewClass ] ];
				addActionWith: [ :action |
						action
							priority: 240;
							name: 'New trait';
							description: 'Add a new trait';
							iconName: 'new-file';
							action: [ self doRequestNewTrait ] ] ]
]

{ #category : 'actions' }
PulsarBaseProjectView >> doCollapseAll [

	listPresenter
		unselectAll;
		collapseAll
]

{ #category : 'actions' }
PulsarBaseProjectView >> doRemoveClass [

	| parentPath |
	parentPath := listPresenter selection selectedPath allButLast.
	self application schedule: [
			(ReRemoveClassDriver newApplication: self application)
				classes: { self selectedEntity };
				model: RBBrowserEnvironment new;
				scopes: { RBBrowserEnvironment new };
				runRefactoring.
			listPresenter selectPath: parentPath scrollToSelection: true ]
]

{ #category : 'actions' }
PulsarBaseProjectView >> doRemoveSelectedEntity [

	listPresenter selectedItem ifNotNil: [ :aModel | (PulsarProjectRemoveModel on: self) visit: aModel realModel ]
]

{ #category : 'actions' }
PulsarBaseProjectView >> doRenameClass [

	| parentPath |
	parentPath := listPresenter selection selectedPath allButLast.
	self application schedule: [
			(ReRenameClassDriver newApplication: self owner application)
				oldName: self selectedEntityName asSymbol;
				model: RBBrowserEnvironment new;
				scopes: { RBBrowserEnvironment new };
				runRefactoring.
			listPresenter selectPath: parentPath scrollToSelection: true ]
]

{ #category : 'actions' }
PulsarBaseProjectView >> doRenameSelectedEntity [

	listPresenter selectedItem ifNotNil: [ :aModel | (PulsarProjectRenameModel on: self) visit: aModel realModel ]
]

{ #category : 'actions' }
PulsarBaseProjectView >> doRequestNewClass [
	| parent |
	
	parent := self closestEntityInPathMatching: [ :each | each isPackageOrTag ].
	parent ifNil: [ ^ self ].

	self notifyActivateEntity: (PvClassModel newEnvironment: self model environmentModel beNewClassWithParent: parent)
]

{ #category : 'actions' }
PulsarBaseProjectView >> doRequestNewTrait [

	| parent |
	parent := self closestEntityInPathMatching: [ :each | each isPackageOrTag ].
	parent ifNil: [ ^ self ].

	self notifyActivateEntity: (PvClassModel newEnvironment: self model environmentModel beNewTraitWithParent: parent)
]

{ #category : 'private' }
PulsarBaseProjectView >> entityActivated: anEntity [ 

	self notifyActivateEntity: anEntity
]

{ #category : 'private' }
PulsarBaseProjectView >> entitySelected: anEntity [ 

	self notifySelectEntity: anEntity
]

{ #category : 'events' }
PulsarBaseProjectView >> eventBehaviorAdded: anAnnouncement [

	| classAdded path |
	classAdded := anAnnouncement classAdded.
	path := self model findPathForClass: classAdded.
	path ifNotNil: [ self refreshProjectPath: path ]
]

{ #category : 'events' }
PulsarBaseProjectView >> eventBehaviorRemoved: anAnnouncement [

	| classRemoved path |
	classRemoved := anAnnouncement classRemoved.
	path := self model findPathForPackage: classRemoved package.
	self refreshProjectPath: path
]

{ #category : 'events' }
PulsarBaseProjectView >> eventBehaviorRenamed: anAnnouncement [

	| classRenamed path |
	classRenamed := anAnnouncement classRenamed.
	path := self model findPathForClass: classRenamed.
	path ifNotNil: [ self refreshProjectPath: path ]
]

{ #category : 'events' }
PulsarBaseProjectView >> eventEditorActivated: anAnnouncement [

	| editorModel classModel path |
	editorModel := anAnnouncement value model.
	editorModel includesClassModel ifFalse: [ ^ self ].

	classModel := editorModel asClassModel.
	(listPresenter selectedItem isNotNil and: [ listPresenter selectedItem realModel = classModel ]) ifTrue: [ ^ self ].

	path := self model findPathForClassModel: classModel.
	path ifNil: [ ^ self ].

	mutex critical: [ listPresenter selectPath: path ]
]

{ #category : 'filtering' }
PulsarBaseProjectView >> filterStartingSize [

	^ 3
]

{ #category : 'selection' }
PulsarBaseProjectView >> hasSelectedClass [

	^ self selectedEntity ifNotNil: [ :anEntityModel | anEntityModel realModel isClassModel ] ifNil: [ false ]
]

{ #category : 'selection' }
PulsarBaseProjectView >> hasSelectedEntity [

	^ self selectedEntity isNotNil
]

{ #category : 'initialization' }
PulsarBaseProjectView >> initialize [

	mutex := Mutex new.
	super initialize
]

{ #category : 'initialization' }
PulsarBaseProjectView >> initializeFilter [

	filterListPresenter := self newEasyListView
		                       addStyle: 'stList';
		                       addStyle: 'pulsarProjectFilterList';
		                       display: [ :aModel | aModel name ];
		                       rowPresenterClass: PulsarProjectNodeRow;
		                       actions: (SpActionGroup new
				                        add: self actions;
				                        addDynamicGroup: #dynamic with: [ :group | group add: self refactorActions ];
				                        addShortcutWith: [ :action |
						                        action
							                        shortcutKey: KeyboardKey right asKeyCombination;
							                        action: [ self activateContextPopover ] ];
				                        addShortcutWith: [ :action |
						                        action
							                        shortcutKey: KeyboardKey left asKeyCombination | KeyboardKey escape asKeyCombination;
							                        action: [ self deactivateContextPopover ] ];
				                        yourself);
		                       yourself.

	filterListPresenter hide.

	filterInputPresenter := self newTextInput
		                        addStyle: 'flat';
		                        placeholder: ('Filter ({1}+ characters)...' format: { self filterStartingSize });
		                        yourself
]

{ #category : 'initialization' }
PulsarBaseProjectView >> intializeProjectTree [

	listPresenter := self newEasyTreeListView
		                 addStyle: 'stTree';
		                 addStyle: 'pulsarProjectTree';
		                 children: [ :aModel | aModel children ];
		                 rowPresenterClass: PulsarProjectNodeRow;
		                 searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		                 actions: (SpActionGroup new
				                  add: self actions;
				                  addDynamicGroup: #dynamic with: [ :group | group add: self refactorActions ];
				                  addShortcutWith: [ :action |
						                  action
							                  shortcutKey: KeyboardKey right asKeyCombination;
							                  action: [ self activateContextPopover ] ];
				                  addShortcutWith: [ :action |
						                  action
							                  shortcutKey: KeyboardKey left asKeyCombination | KeyboardKey escape asKeyCombination;
							                  action: [ self deactivateContextPopover ] ];
				                  yourself);
		                 yourself
]

{ #category : 'events' }
PulsarBaseProjectView >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'events' }
PulsarBaseProjectView >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].
	self notificationCenter announce: anEntity realModel newSelectionAnnouncement
]

{ #category : 'actions' }
PulsarBaseProjectView >> refactorActions [

	self hasSelectedEntity ifFalse: [ ^ SpActionGroup new ].

	^ self selectedEntity realModel actionsWithContextOn: self
]

{ #category : 'events' }
PulsarBaseProjectView >> registerToEvents [

	super registerToEvents.
	self announcer when: PulsarEditorActivated send: #eventEditorActivated: to: self
]

{ #category : 'events' }
PulsarBaseProjectView >> registerToSystemEvents [

	self announcer
		when: ClassAdded send: #eventBehaviorAdded: to: self;
		when: ClassRemoved send: #eventBehaviorRemoved: to: self;
		when: ClassRenamed send: #eventBehaviorRenamed: to: self
]

{ #category : 'selection' }
PulsarBaseProjectView >> selectedEntitiesInPath [

	^ listPresenter selection selectedItemsInPath
]

{ #category : 'selection' }
PulsarBaseProjectView >> selectedEntity [

	^ listPresenter ifNotNil: #selectedItem
]

{ #category : 'selection' }
PulsarBaseProjectView >> selectedEntityName [

	^ self selectedEntity ifNotNil: [ :anEntityModel | anEntityModel name ] ifNil: [ 'None' ]
]

{ #category : 'accessing' }
PulsarBaseProjectView >> toolbarPresenter [

	^ toolbarPresenter
]

{ #category : 'filtering' }
PulsarBaseProjectView >> updateFilterWith: aString [

	(aString isEmptyOrNil or: [ aString size < self filterStartingSize ]) ifTrue: [
			self application defer: [
					listPresenter show.
					filterListPresenter hide ].
			^ self ].

	self scheduleTask: [
			| items |
			items := self model filterWith: aString.
			self application defer: [
					listPresenter hide.
					filterListPresenter show.
					filterListPresenter items: items ] ]
]

{ #category : 'updating' }
PulsarBaseProjectView >> updateToolbar [

	self actions allCommands do: [ :each | each updateEnableStatus ]
]
