"
A container specialised on keeping editors.
"
Class {
	#name : 'PvEditorContainerPresenter',
	#superclass : 'PvContainerPresenter',
	#traits : 'SpTSelectable - {#select}',
	#classTraits : 'SpTSelectable classTrait',
	#category : 'Perspective-View-Container',
	#package : 'Perspective',
	#tag : 'View-Container'
}

{ #category : 'accessing' }
PvEditorContainerPresenter class >> defaultContainerName [

	^ #edit
]

{ #category : 'accessing' }
PvEditorContainerPresenter class >> defaultTitle [

	^ 'View'
]

{ #category : 'converting' }
PvEditorContainerPresenter >> asEditorContainer [

	^ self
]

{ #category : 'private - events' }
PvEditorContainerPresenter >> entityActivated: aModel [
	| editor editorWindow |

	self presenters 
		detect: [ :each | each presenter model = aModel ]
		ifFound: [ :each | ^ self layout select: each  ].
	"Add the editor"
	editor := self instantiate: aModel editorClass on: aModel.
	editorWindow := self contentLayout addTileWindow: editor.
	self contentLayout select: editorWindow.
	editor takeKeyboardFocus
]

{ #category : 'private - events' }
PvEditorContainerPresenter >> entitySelected: anEntity [

	self halt
]

{ #category : 'events - handling' }
PvEditorContainerPresenter >> handleAnnouncement: anAnnouncement [

	anAnnouncement handleOn: self
]

{ #category : 'initialization' }
PvEditorContainerPresenter >> initialize [

	super initialize.
	self announcer 
		when: LnTabLayoutActivated 
		send: #tabLayoutActivated
		to: self
]

{ #category : 'initialization' }
PvEditorContainerPresenter >> initializePresenters [

	super initializePresenters.
	self addStyle: 'pvEditorContainer'.
	"self 
		bindKeyCombination: $w control 
		toAction: [ self halt ]"
]

{ #category : 'transmission' }
PvEditorContainerPresenter >> inputActivatedPort [

	^ PvEntityActivatedPort newPresenter: self
]

{ #category : 'transmission' }
PvEditorContainerPresenter >> inputSelectedPort [

	^ PvEntitySelectedPort newPresenter: self
]

{ #category : 'private - actions' }
PvEditorContainerPresenter >> selectWith: anObject [

	anObject ifNil: [ ^ self ].
	self selectionAction ifNil: [ ^ self ].
	self selectionAction cull: (SpActivatedSelection newValue: anObject)
]

{ #category : 'private' }
PvEditorContainerPresenter >> tabLayoutActivated [

	self layout announcer
		when: SpTabSelected 
		send: #tabSelected: 
		to: self
]

{ #category : 'private' }
PvEditorContainerPresenter >> tabSelected: ann [

	"aSelection ifNil: [ ^ self ]."
	self flag: #TODO. "
	ann presenter -> the window.
	ann presenter presenter -> the window contents"
	self selectWith: ann presenter presenter model
]
