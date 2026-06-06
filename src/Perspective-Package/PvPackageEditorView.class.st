"
A PvPackageEditorView is an editor that displays package information and allows editing the package comment.

It extends PvEditorView and provides a text area where the package comment (read from or written to a PackageManifest subclass) can be viewed and saved.
"
Class {
	#name : 'PvPackageEditorView',
	#superclass : 'PvEditorView',
	#category : 'Perspective-Package-View',
	#package : 'Perspective-Package',
	#tag : 'View'
}

{ #category : 'updating' }
PvPackageEditorView >> content: aString [

	editorPresenter text: aString
]

{ #category : 'updating' }
PvPackageEditorView >> doSubmit: aString [

	self model saveComment: aString withInternalLineEndings.
	self resetDirty
]

{ #category : 'initialization' }
PvPackageEditorView >> editorHeaderClass [

	^ PvEditorHeaderPresenter
]

{ #category : 'accessing' }
PvPackageEditorView >> title [

	^ self model ifNotNil: [ :aModel | aModel windowTitle ]
]

{ #category : 'updating' }
PvPackageEditorView >> updatePresenter [

	super updatePresenter.
	self updatingWhile: [ editorPresenter text: self model commentOrTemplate ]
]
