"
I am the editor presented in the FFI tab of a method. I show the C-style signature of a simple ffiCall: method in a text editor and recompile the method when the signature is saved.
"
Class {
	#name : 'PulsarFFIEditor',
	#superclass : 'PulsarEditor',
	#instVars : [
		'textPresenter'
	],
	#category : 'Pulsar-Tool-FileEditor',
	#package : 'Pulsar-Tool-FileEditor'
}

{ #category : 'initialization' }
PulsarFFIEditor >> connectPresenters [

	textPresenter
		whenTextChangedDo: [ :newText :oldText | self textChangedFrom: oldText to: newText ];
		whenSubmitDo: [ :aString | self doSubmit: aString ];
		whenResetDo: [ self doReset ]
]

{ #category : 'accessing' }
PulsarFFIEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPresenter expand: false;
		  add: (self editorOverlayLayout
				   child: textPresenter;
				   yourself)
		  expand: true;
		  yourself
]

{ #category : 'updating' }
PulsarFFIEditor >> doReset [

	self updatingWhile: [ self updatePresenter ]
]

{ #category : 'updating' }
PulsarFFIEditor >> doSubmit: aString [
	"Compile the method with the given C-style signature and refresh the editor on success."

	| result oldModel |
	oldModel := self model copy.
	result := self model updateWith: aString.
	result ifTrue: [
			self unmarkDirty.
			self notifyModelChangedFrom: oldModel to: self model.
			self updatePresenter ].
	^ result
]

{ #category : 'initialization' }
PulsarFFIEditor >> initializeEditor [

	textPresenter := self newTextInput
]

{ #category : 'initialization' }
PulsarFFIEditor >> initializePresenters [

	self addStyle: 'pulsarEditor'.
	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter actions: self editorToolbarActions.
	self initializeEditor
]

{ #category : 'accessing' }
PulsarFFIEditor >> originalContent [
	"Answer the original C-style signature text, used to decide if the editor is dirty."

	^ self model ffiText
]

{ #category : 'updating' }
PulsarFFIEditor >> saveContent [

	^ self doSubmit: textPresenter text
]

{ #category : 'accessing' }
PulsarFFIEditor >> textPresenter [

	^ textPresenter
]

{ #category : 'updating' }
PulsarFFIEditor >> updatePresenter [

	super updatePresenter.
	self model ifNil: [ ^ self ].
	textPresenter ifNil: [ ^ self ].
	self updatingWhile: [ textPresenter text: self model ffiText ].
	self unmarkDirty
]
