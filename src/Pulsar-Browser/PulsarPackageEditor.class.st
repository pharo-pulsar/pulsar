"
PulsarPackageEditor is the Pulsar editor for packages.

It provides a comment editor to view and edit the package description stored in the package's manifest class (a subclass of PackageManifest).
"
Class {
	#name : 'PulsarPackageEditor',
	#superclass : 'PulsarEditor',
	#instVars : [
		'commentPresenter',
		'commentOverlayLayout',
		'dependenciesPresenter',
		'classesTreePresenter',
		'mutex',
		'expandedItems'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'visiting' }
PulsarPackageEditor >> acceptVisitor: aVisitor [

	^ aVisitor visitPackageEditor: self
]

{ #category : 'accessing - overlay' }
PulsarPackageEditor >> addOverlay: aPresenter [

	self commentOverlayLayout addOverlay: aPresenter
]

{ #category : 'accessing - overlay' }
PulsarPackageEditor >> addOverlay: aPresenter withConstraints: aBlock [

	self commentOverlayLayout 
		addOverlay: aPresenter 
		withConstraints: aBlock
]

{ #category : 'accessing' }
PulsarPackageEditor >> classesTreePresenter [

	^ classesTreePresenter
]

{ #category : 'private - updating' }
PulsarPackageEditor >> commentChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].

	oldText = newText ifTrue: [ ^ self ].
	
	(self isDirty and: [ newText = self originalContent ]) 
		ifTrue: [ ^ self unmarkDirty ].

	self markDirty
]

{ #category : 'private - overlay' }
PulsarPackageEditor >> commentOverlayLayout [

	^ commentOverlayLayout
]

{ #category : 'initialization' }
PulsarPackageEditor >> connectPresenters [

	super connectPresenters.

	commentPresenter
		whenTextChangedDo: [ :newText :oldText | self commentChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSaveComment: aString ];
		whenResetDo: [ self doResetComment ].

	classesTreePresenter outputSelectionPort transmitDo: [ :anEntity | self entitySelected: anEntity ].
	classesTreePresenter outputActivationPort transmitDo: [ :anEntity | self entityActivated: anEntity ]
]

{ #category : 'layout' }
PulsarPackageEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: ((commentOverlayLayout := SpOverlayLayout new)
				child: commentPresenter;
				yourself);
			add: (SpTabLayout new 
				add: dependenciesPresenter label: 'Dependencies';
				add: classesTreePresenter label: 'Classes'; 
				yourself);
			yourself);
		yourself
]

{ #category : 'private - definitions' }
PulsarPackageEditor >> defineClassesActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #navigation with: [ :group |
			group
				priority: 100;
				name: 'Navigation';
				beDisplayedAsGroup.
			group addActionWith: [ :action |
					action
						priority: 110;
						name: 'New class';
						description: 'Add a new class to this package';
						iconName: 'new-file';
						action: [ self doNewClass ] ] ]
]

{ #category : 'private - definitions' }
PulsarPackageEditor >> defineNavigationActionsOn: aBuilder [

	<dockActions>
	
]

{ #category : 'actions' }
PulsarPackageEditor >> doNewClass [

	| newClassModel |
	newClassModel := PvClassModel newEnvironment: self model environmentModel beNewClassWithParent: self model.

	self notifyActivateEntity: newClassModel
]

{ #category : 'private - actions' }
PulsarPackageEditor >> doReset [

	self updatingWhile: [
		commentPresenter text: self originalContent.
		self unmarkDirty ]
]

{ #category : 'private - comment' }
PulsarPackageEditor >> doResetComment [

	self updateComment.
	self unmarkDirty
]

{ #category : 'private - comment' }
PulsarPackageEditor >> doSaveComment: aString [

	self model saveComment: aString
]

{ #category : 'private - actions' }
PulsarPackageEditor >> doSubmit: aString [

	self doSaveComment: aString.
	self unmarkDirty
]

{ #category : 'private' }
PulsarPackageEditor >> entityActivated: anEntity [

	self notifyActivateEntity: anEntity
]

{ #category : 'private' }
PulsarPackageEditor >> entitySelected: anEntity [

	self notifySelectEntity: anEntity
]

{ #category : 'events' }
PulsarPackageEditor >> eventClassAdded: anAnnouncement [

	anAnnouncement classAdded package = self model package ifTrue: [ self updateClassesTree ]
]

{ #category : 'events' }
PulsarPackageEditor >> eventClassRemoved: anAnnouncement [

	anAnnouncement classRemoved package = self model package ifTrue: [ self updateClassesTree ]
]

{ #category : 'events' }
PulsarPackageEditor >> eventClassRenamed: anAnnouncement [

	anAnnouncement classRenamed package = self model package ifTrue: [ self updateClassesTree ]
]

{ #category : 'events' }
PulsarPackageEditor >> eventModelRemoved: anAnnouncememnt [ 

	anAnnouncememnt value = self model ifFalse: [ ^ self ].

	self withPanelWidgetDo: [ :aPanelWindow | aPanelWindow close ]
]

{ #category : 'events' }
PulsarPackageEditor >> eventTestCaseEnded: aTestCaseEnded [
	"do nothing"
]

{ #category : 'events' }
PulsarPackageEditor >> eventThemeChanged: ann [

	super eventThemeChanged: ann.
	commentPresenter styleScheme: self application styleScheme
]

{ #category : 'accessing' }
PulsarPackageEditor >> expandedItems [

	^ expandedItems ifNil: [ expandedItems := Set new ]
]

{ #category : 'accessing' }
PulsarPackageEditor >> expandedItems: aCollection [

	expandedItems := aCollection asSet
]

{ #category : 'updating' }
PulsarPackageEditor >> findPathOf: aModel in: aCollection [

	| subPath |
	aCollection withIndexDo: [ :each :index |
			each = aModel ifTrue: [ ^ { index } ].
			subPath := self findPathOf: aModel in: each children.
			subPath first isZero ifFalse: [ ^ { index } , subPath ] ].

	^ { 0 }
]

{ #category : 'selection' }
PulsarPackageEditor >> hasSelectedEntity [

	^ self selectedEntity isNotNil
]

{ #category : 'initialization' }
PulsarPackageEditor >> initialize [

	mutex := Mutex new.
	super initialize
]

{ #category : 'initialization' }
PulsarPackageEditor >> initializeClassesTree [

	classesTreePresenter := self newEasyTreeListView
		                        addStyle: 'stTree';
		                        addStyle: 'pulsarPackageClassesTree';
		                        children: [ :aNode | aNode children ];
		                        rowPresenterClass: PulsarProjectNodeRow;
		                        searchMatching: [ :anEntity :pattern | anEntity matches: pattern ];
		                        actions: (SpActionGroup new
				                         add: self actions;
				                         addDynamicGroup: #dynamic with: [ :group | group add: self refactorActions ];
				                         yourself);
		                        whenExpandChangedDo: [ :ann | self registerExpansionOf: ann ];
		                        yourself
]

{ #category : 'initialization' }
PulsarPackageEditor >> initializePresenters [

	super initializePresenters.

	self addStyle: 'pulsarPackageEditor'.

	commentPresenter := (self instantiate: SeEditorPresenter)
		                    addStyle: 'stCode';
		                    withoutLineNumbers;
		                    withHyperlinks;
		                    yourself.

	dependenciesPresenter := self instantiate: PulsarPackageDependenciesPresenter.
	self initializeClassesTree
]

{ #category : 'private' }
PulsarPackageEditor >> newDirtyMarkerPresenter [

	^ self newToolbar
	  addStyle: 'pulsarDirtyMarker';
	  beIcons;
	  add: (self newToolbarButton
		addStyle: 'accept';
		icon: (self iconNamed: #accept);
		action: [ self doSubmit: commentPresenter text ];
		help: 'Accept changes';
		yourself);
	  add: (self newToolbarButton
		addStyle: 'cancel';
		icon: (self iconNamed: #cancel);
		action: [ self doReset ];
		help: 'Cancel changes';
		yourself);
	  yourself
]

{ #category : 'events' }
PulsarPackageEditor >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].

	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'events' }
PulsarPackageEditor >> notifySelectEntity: anEntity [

	anEntity ifNil: [ ^ self ].

	self notificationCenter announce: anEntity realModel newSelectionAnnouncement
]

{ #category : 'private' }
PulsarPackageEditor >> originalContent [

	^ self model commentOrTemplate
]

{ #category : 'updating' }
PulsarPackageEditor >> pathIndexOf: aModel [
	"Answer the 1-based path locating aModel within the tree contents, or a path containing zero when not found."

	^ self findPathOf: aModel in: self classesTreePresenter roots
]

{ #category : 'actions' }
PulsarPackageEditor >> refactorActions [

	self hasSelectedEntity ifFalse: [ ^ SpActionGroup new ].

	^ self selectedEntity realModel actionsWithContextOn: self
]

{ #category : 'updating' }
PulsarPackageEditor >> registerExpansionOf: ann [

	ann expanded
		ifTrue: [ self expandedItems add: ann item ]
		ifFalse: [ self expandedItems remove: ann item ifAbsent: [ ] ]
]

{ #category : 'initialization' }
PulsarPackageEditor >> registerToSystemEvents [

	super registerToSystemEvents.

	self announcer
		when: ClassAdded send: #eventClassAdded: to: self;
		when: ClassRemoved send: #eventClassRemoved: to: self;
		when: ClassRenamed send: #eventClassRenamed: to: self
]

{ #category : 'accessing - overlay' }
PulsarPackageEditor >> removeOverlay: aPresenter [

	self commentOverlayLayout removeOverlay: aPresenter
]

{ #category : 'private' }
PulsarPackageEditor >> resetExpandedItems [

	expandedItems := Set new
]

{ #category : 'updating' }
PulsarPackageEditor >> restoreExpandedBranchesFrom: aCollection [
	"Re-expand the branches that were open before the last refresh."

	mutex critical: [
			aCollection copy do: [ :each |
					| path |
					path := self pathIndexOf: each.
					path first isZero
						ifTrue: [ self expandedItems remove: each ifAbsent: [ ] ]
						ifFalse: [ classesTreePresenter expandPath: path ] ] ]
]

{ #category : 'private - actions' }
PulsarPackageEditor >> saveContent [

	^ self doSaveComment: commentPresenter text
]

{ #category : 'private' }
PulsarPackageEditor >> selectedEntity [

	^ classesTreePresenter ifNotNil: #selectedItem
]

{ #category : 'updating' }
PulsarPackageEditor >> updateBreadcrumbs [
	| name |
	
	name := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: name ]
]

{ #category : 'updating' }
PulsarPackageEditor >> updateClassesTree [

	| remembered |
	mutex critical: [
			remembered := self expandedItems copy.
			classesTreePresenter roots: (PvClassHierarchyBuilder buildFrom: self model classes).
			self restoreExpandedBranchesFrom: remembered ]
]

{ #category : 'updating' }
PulsarPackageEditor >> updateComment [

	self updatingWhile: [ 
		commentPresenter text: self model commentOrTemplate ]
]

{ #category : 'updating' }
PulsarPackageEditor >> updateEditor [

	dependenciesPresenter model: self model newDependencyModel
]

{ #category : 'updating' }
PulsarPackageEditor >> updatePresenter [

	commentPresenter
		styleScheme: self application styleScheme;
		language: 'markdown'.

	self model ifNil: [ ^ self ].

	super updatePresenter.
	self updateComment.
	self updateEditor.
	self updateClassesTree
]
