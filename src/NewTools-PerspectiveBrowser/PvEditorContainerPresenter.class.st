"
A container specialised on keeping editors.
"
Class {
	#name : #PvEditorContainerPresenter,
	#superclass : #PvContainerPresenter,
	#traits : 'PvTModelVisitor',
	#classTraits : 'PvTModelVisitor classTrait',
	#category : #'NewTools-PerspectiveBrowser-View'
}

{ #category : #accessing }
PvEditorContainerPresenter class >> defaultContainerName [

	^ #edit
]

{ #category : #accessing }
PvEditorContainerPresenter class >> defaultTitle [

	^ 'View'
]

{ #category : #converting }
PvEditorContainerPresenter >> asEditorContainer [

	^ self
]

{ #category : #'events - handling' }
PvEditorContainerPresenter >> entityActivated: ann [

	ann model accept: self
]

{ #category : #initialization }
PvEditorContainerPresenter >> initialize [

	super initialize.
	self subscribeToAnnouncements.
	self announcer 
		when: LnTabLayoutActivated 
		send: #tabLayoutActivated
		to: self
]

{ #category : #private }
PvEditorContainerPresenter >> tabLayoutActivated [

	self layout announcer
		when: SpTabSelected 
		send: #tabSelected: 
		to: self
]

{ #category : #private }
PvEditorContainerPresenter >> tabSelected: ann [

	"aSelection ifNil: [ ^ self ]."
	self halt.
	self owner announcer announce: (PvSelectedAnnouncement for: ann presenter)
]

{ #category : #visiting }
PvEditorContainerPresenter >> visitMethodModel: aModel [
	| editor editorWindow |

	self presenters 
		detect: [ :each | each presenter model = aModel ]
		ifFound: [ :each | ^ self layout select: each  ].
	"Add the editor"
	editor := self instantiate: aModel editorClass on: aModel.
	editorWindow := self layout addTileWindow: editor.
	self layout select: editorWindow
]
