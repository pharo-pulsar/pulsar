"
PulsarPackageDependenciesPresenter displays the dependencies of a package in a two-pane view.

It shows outgoing dependencies (packages this package depends on) by default,
and supports toggling to incoming dependencies (packages that depend on this package).
The header uses a PulsarToolbarPresenter with a summary label and a direction toggle button.
"
Class {
	#name : 'PulsarPackageDependenciesPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'headerToolbar',
		'packagesList',
		'dependenciesItems',
		'summaryLabel',
		'directionToggle',
		'model'
	],
	#category : 'Pulsar-Browser-Tool-Package-Dependencies',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Package-Dependencies'
}

{ #category : 'initialization' }
PulsarPackageDependenciesPresenter >> connectPresenters [

	super connectPresenters.

	directionToggle whenChangedDo: [ :state | self toggleDirection ].

	packagesList
		transmitTo: dependenciesItems
		transform: [ :selected |
			selected 
				ifNotNil: [ self model dependencyItemsFor: selected ]
				ifNil: [ #() ]  ].

	dependenciesItems outputActivationPort transmitDo: [ :dependency |
		(dependency browsableEntityOn: self environmentModel)
			ifNotNil: [ :entity | self notifyActivateEntity: entity ] ]
]

{ #category : 'layout' }
PulsarPackageDependenciesPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: headerToolbar expand: false;
		add: (SpPanedLayout newHorizontal
			add: packagesList;
			add: dependenciesItems;
			yourself);
		yourself
]

{ #category : 'private' }
PulsarPackageDependenciesPresenter >> environmentModel [

	^ self owner model environmentModel
]

{ #category : 'initialization' }
PulsarPackageDependenciesPresenter >> initialize [

	super initialize
]

{ #category : 'initialization' }
PulsarPackageDependenciesPresenter >> initializePresenters [

	super initializePresenters.

	self addStyle: 'pulsarPackageDependencies'.

	headerToolbar := self instantiate: PulsarEditorToolbarPresenter.
	headerToolbar title: 'No package analyzed'.

	directionToggle := self newToggleButton
		addStyle: 'flat';
		icon: (self iconNamed: 'flip-side');
		help: 'Show incoming dependencies';
		state: false;
		yourself.

	headerToolbar addPresenter: directionToggle.

	packagesList := self newFilteringList
		addStyle: 'stList';
		display: [ :each |
			| total |
			total := (self model compositesByTarget at: each ifAbsent: [ #() ])
				inject: 0
				into: [ :sum :comp | sum + comp dependencies size ].
			each packageName , ' (' , total asString , ' items)' ];
		displayIcon: [ :each | self iconNamed: #package ];
		enableSearch;
		yourself.

	dependenciesItems := self newFilteringList
		addStyle: 'stList';
		display: [ :each | each displayString ];
		displayIcon: [ :each | self iconNamed: each nodeClass new iconName ];
		enableSearch;
		yourself
]

{ #category : 'accessing' }
PulsarPackageDependenciesPresenter >> notificationCenter [

	^ self owner notificationCenter
]

{ #category : 'private - announcing' }
PulsarPackageDependenciesPresenter >> notifyActivateEntity: anEntity [

	anEntity ifNil: [ ^ self ].

	self notificationCenter announce: anEntity newActivationAnnouncement
]

{ #category : 'events' }
PulsarPackageDependenciesPresenter >> toggleDirection [

	self model toggleDirection.
	directionToggle help: (self model direction = #outgoing
			 ifTrue: [ 'Show incoming dependencies' ]
			 ifFalse: [ 'Show outgoing dependencies' ]).
	self updatePresenter
]

{ #category : 'updating' }
PulsarPackageDependenciesPresenter >> updateForPackageName: aPackageName [

	self model: (PulsarPackageDependencyModel new
			 packageName: aPackageName;
			 yourself)
]

{ #category : 'initialization' }
PulsarPackageDependenciesPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	headerToolbar title: self model summaryLabel.
	packagesList items: self model dependencyData.
	dependenciesItems items: #()
]
