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
		'dependenciesPresenter'
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
		whenResetDo: [ self doResetComment ]
]

{ #category : 'layout' }
PulsarPackageEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: ((commentOverlayLayout := SpOverlayLayout new)
				child: commentPresenter;
				yourself);
			add: dependenciesPresenter;
			yourself);
		yourself
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

{ #category : 'events' }
PulsarPackageEditor >> eventThemeChanged: ann [

	super eventThemeChanged: ann.
	commentPresenter styleScheme: self application styleScheme
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

	dependenciesPresenter := self instantiate: PulsarPackageDependenciesPresenter
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

{ #category : 'private' }
PulsarPackageEditor >> originalContent [

	^ self model commentOrTemplate
]

{ #category : 'accessing - overlay' }
PulsarPackageEditor >> removeOverlay: aPresenter [

	self commentOverlayLayout removeOverlay: aPresenter
]

{ #category : 'private - actions' }
PulsarPackageEditor >> saveContent [

	^ self doSaveComment: commentPresenter text
]

{ #category : 'updating' }
PulsarPackageEditor >> updateBreadcrumbs [
	| name |
	
	name := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | 
		aBreadcrumb addSegment: name ]
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
	self updateEditor
]
