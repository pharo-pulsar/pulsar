Class {
	#name : #PvProjectView,
	#superclass : #PvPerspectiveView,
	#instVars : [
		'projectTreePresenter'
	],
	#category : #'Perspective-Project-View'
}

{ #category : #accessing }
PvProjectView class >> defaultContainerName [

	^ #overview
]

{ #category : #accessing }
PvProjectView class >> defaultTitle [

	^ 'Project'
]

{ #category : #initialization }
PvProjectView >> connectPresenters [

	projectTreePresenter outputSelectionPort
		transmitDo: [ :aSelection | self selectWith: aSelection ].
	projectTreePresenter outputActivationPort
		transmitDo: [ :aSelection | self activateWith: aSelection ]
]

{ #category : #actions }
PvProjectView >> doNewClass [
	| items parentModel |

	items := projectTreePresenter selection selectedItemsInPath.
	items ifEmpty: [ self error: 'TODO' ].

	parentModel := items reversed detect: [ :each | each isPackageOrTag ].
		
	self activateWith: (PvNewClassModel
		newEnvironment: self model environmentModel
		entity: (PvNewClassTemplate new
			parentModel: parentModel;
			yourself))

	"newClass := (PvClassCreationDialog 
			newApplication: self application 
			model: packageModel) 
		openModalWithParent: self window.
	newClass ifNil: [ ^ self ]."

]

{ #category : #actions }
PvProjectView >> doOpenProject [
	
	self halt
		
]

{ #category : #'private - events' }
PvProjectView >> entitySelected: aModel [

	projectTreePresenter selectedItem = aModel ifTrue: [ ^ self ].
	projectTreePresenter selectItem: aModel
]

{ #category : #initialization }
PvProjectView >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (projectTreePresenter := self newEntityTree);
		yourself).

	projectTreePresenter addStyle: 'stProjectTree'.
	projectTreePresenter contextMenu: [ self toolbarActions asMenuPresenter ].
	projectTreePresenter contextKeyBindings: self toolbarActions asKMCategory
]

{ #category : #initialization }
PvProjectView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter toolbar: self toolbar
]

{ #category : #initialization }
PvProjectView >> toolbar [

	^ self 
		newPerspectiveViewToolbar: #project 
		actions: #actions
]

{ #category : #initialization }
PvProjectView >> toolbarActions [

	^ PvProjectCommand buildToolbarOn: self
]

{ #category : #initialization }
PvProjectView >> updatePresenter [

	self model ifNil: [ ^ self ].
	projectTreePresenter 
		roots: { self model };
		expandRoots.
	"self withTileWindowDo: [ :w | 
		w windowIcon: (self model windowIconComposite buildOn: self application).
		w title: self title ]"
]
