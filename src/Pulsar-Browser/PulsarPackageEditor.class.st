"
PulsarPackageEditor is the Pulsar editor for packages.

It provides a comment editor to view and edit the package description stored in the package's manifest class (a subclass of PackageManifest).
"
Class {
	#name : 'PulsarPackageEditor',
	#superclass : 'PulsarEditor',
	#instVars : [
		'commentPresenter',
		'commentOverlayLayout'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'visiting' }
PulsarPackageEditor >> acceptVisitor: aVisitor [

	^ aVisitor visitPackageEditor: self
]

{ #category : 'private - comment' }
PulsarPackageEditor >> commentChangedFrom: oldText to: newText [

	self isUpdating ifTrue: [ ^ self ].

	oldText = newText ifTrue: [ ^ self ]
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
		  add: ((commentOverlayLayout := SpOverlayLayout new)
				   child: commentPresenter;
				   yourself);
		  yourself
]

{ #category : 'private - comment' }
PulsarPackageEditor >> doResetComment [

	self updateComment
]

{ #category : 'private - comment' }
PulsarPackageEditor >> doSaveComment: aString [

	self model saveComment: aString
]

{ #category : 'events' }
PulsarPackageEditor >> eventThemeChanged: ann [

	super eventThemeChanged: ann.
	commentPresenter styleScheme: self application styleScheme
]

{ #category : 'initialization' }
PulsarPackageEditor >> initialize [

	super initialize
]

{ #category : 'initialization' }
PulsarPackageEditor >> initializePresenters [

	super initializePresenters.

	self addStyle: 'pulsarPackageEditor'.

	commentPresenter := (self instantiate: SeEditorPresenter)
		                    addStyle: 'stCode';
		                    withoutLineNumbers;
		                    withHyperlinks;
		                    yourself
]

{ #category : 'updating' }
PulsarPackageEditor >> updateBreadcrumbs [

	| name |
	name := self model name.
	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb | aBreadcrumb addSegment: name ]
]

{ #category : 'updating' }
PulsarPackageEditor >> updateComment [

	self updatingWhile: [ commentPresenter text: self model commentOrTemplate ]
]

{ #category : 'updating' }
PulsarPackageEditor >> updateEditor [
	"Package editor currently only edits the comment."

	
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
