"
I am the editor presented in the FFI tab of a method. I show the C-style signature of a simple ffiCall: method in a text editor and recompile the method when the signature is saved.
"
Class {
	#name : 'PulsarFFIEditor',
	#superclass : 'PulsarEditor',
	#category : 'Pulsar-Tool-FileEditor',
	#package : 'Pulsar-Tool-FileEditor'
}

{ #category : 'initialization' }
PulsarFFIEditor >> initializeEditor [

	editorPresenter := self instantiate: SeEditorPresenter.
	editorPresenter
		addStyle: 'editor';
		withEditionContextMenu;
		systemNavigation: (self systemNavigationWithResponder: editorPresenter)
]

{ #category : 'accessing' }
PulsarFFIEditor >> originalContent [
	"Answer the original C-style signature text, used to decide if the editor is dirty."

	^ self model ffiText
]

{ #category : 'updating' }
PulsarFFIEditor >> updateModel: aString [
	"Update the model with the given C-style signature. SeEditorPresenter has no interactionModel, so delegate to the 1-arg updateWith: like PulsarFileEditor."

	^ self model updateWith: aString
]

{ #category : 'events' }
PulsarFFIEditor >> updatePresenter [

	super updatePresenter.
	self model ifNil: [ ^ self ].
	editorPresenter language: 'c'.
	self updatingWhile: [ editorPresenter text: self model ffiText ].
	self unmarkDirty
]
