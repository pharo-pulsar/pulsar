"
This is an editor to be used on method source.
Its model will be a `PulsarMethodSourceModel`.

It allows the edition of method strings as files (for example, when editing CSS files. 
The method to be edited needs to be decorated with `<pulsarSourceEditor: 'FILETYPE'>` pragma.
"
Class {
	#name : 'PulsarMethodSourceEditor',
	#superclass : 'PulsarFileEditor',
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarMethodSourceEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (self editorOverlayLayout
			child: editorPresenter;
			yourself);
		add: searchBarPresenter expand: false;
		yourself
]

{ #category : 'private - definitions' }
PulsarMethodSourceEditor >> defineActionsOn: aBuilder [
	<dockActions>
]

{ #category : 'initialization' }
PulsarMethodSourceEditor >> ensureMonitoring [
	"this is internal code. In this case monitoring will be listeining to 
	method changes, not file changes. And that should be done in/from the 
	editor"
]
