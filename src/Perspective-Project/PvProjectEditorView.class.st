Class {
	#name : #PvProjectEditorView,
	#superclass : #PvEditorView,
	#instVars : [
		'projectNamePresenter',
		'detailLabelPresenter',
		'dependenceListPresenter'
	],
	#category : #'Perspective-Project-View'
}

{ #category : #layout }
PvProjectEditorView >> defaultLayout [

	^ SpBoxLayout newTopToBottom 
		add: headerPresenter expand: false;
		add: (SpTabLayout new
			add: self newDefinitionLayout label: 'Definition';
			add: editorPresenter label: 'Baseline';
			yourself);
		add: footerPresenter expand: false;
		yourself
]

{ #category : #initialization }
PvProjectEditorView >> initializePresenters [

	super initializePresenters.
		
	projectNamePresenter := self newTextInput.
	dependenceListPresenter := self newList
		display: [ :aSpec | aSpec name ];
		displayIcon: [ :aSpec | self application iconNamed: aSpec iconName ];
		yourself.
	detailLabelPresenter := self newLabel.
	
	self addStyle: 'pvProjectEditor'
]

{ #category : #initialization }
PvProjectEditorView >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model shortName;
		windowIcon: (self model windowIconComposite buildOn: self application)
]

{ #category : #layout }
PvProjectEditorView >> newDefinitionLayout [
		
	^ SpBoxLayout newLeftToRight
		add: (SpBoxLayout newTopToBottom
			add: 'Dependences' expand: false;
			add: dependenceListPresenter;
			yourself);
		add: (SpBoxLayout newTopToBottom
			add: detailLabelPresenter expand: false;
			yourself);
		yourself
]

{ #category : #initialization }
PvProjectEditorView >> title [

	^ self model ifNotNil: [ :aModel | aModel windowTitle ]
]

{ #category : #initialization }
PvProjectEditorView >> updatePresenter [

	dependenceListPresenter items: self model dependencyModels
]
