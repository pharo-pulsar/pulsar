"
A container specialised on keeping editors.
"
Class {
	#name : #PvEditorContainerPresenter,
	#superclass : #PvContainerPresenter,
	#category : #'Perspective-View'
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

{ #category : #'private - activating' }
PvEditorContainerPresenter >> classActivated: aModel [

	self methodActivated: aModel
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

{ #category : #initialization }
PvEditorContainerPresenter >> initializePresenters [

	super initializePresenters.
	"self 
		bindKeyCombination: $w control 
		toAction: [ self halt ]"
]

{ #category : #'private - activating' }
PvEditorContainerPresenter >> methodActivated: aModel [
	| editor editorWindow |

	self presenters 
		detect: [ :each | each presenter model = aModel ]
		ifFound: [ :each | ^ self layout select: each  ].
	"Add the editor"
	editor := self instantiate: aModel editorClass on: aModel.
	editorWindow := self layout addTileWindow: editor.
	self layout select: editorWindow.
	editor takeKeyboardFocus
]

{ #category : #'private - activating' }
PvEditorContainerPresenter >> newClassActivated: aModel [

	self methodActivated: aModel
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
	self flag: #TODO. "
	ann presenter -> the window.
	ann presenter presenter -> the window contents"
	self owner announcer announce: (ann presenter presenter model selectedAnnouncement)
]
