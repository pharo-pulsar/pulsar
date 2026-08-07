"
I am a visitor that selects the tree path corresponding to an editor's model in the project browser.

I walk over project, package, and class editors to find the tree path that matches each editor's model, then tell my owner (a projectview presenter) to highlight that path. If the entity is already selected or no matching path exists, I do nothing.
"
Class {
	#name : 'PulsarProjectSelectEntityVisitor',
	#superclass : 'PulsarEditorVisitor',
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'visiting' }
PulsarProjectSelectEntityVisitor >> visitEditor: anEditor [
	| editorModel classModel path |

	editorModel := anEditor model.
	editorModel includesClassModel ifFalse: [ ^ self ].

	classModel := editorModel asClassModel.
	(owner selectedEntity isNotNil 
		and: [ owner selectedEntity realModel = classModel ]) 
		ifTrue: [ ^ self ].

	path := owner model findPathForClassModel: classModel.
	path ifNil: [ ^ self ].

	owner selectPath: path
]

{ #category : 'visiting' }
PulsarProjectSelectEntityVisitor >> visitPackageEditor: aPackageEditor [
	| editorModel path  |

	editorModel := aPackageEditor model.
	path := owner model findPathForPackage: editorModel.
	path ifNil: [ ^ self ].

	owner selectPath: path
]

{ #category : 'visiting' }
PulsarProjectSelectEntityVisitor >> visitProjectEditor: aProjectEditor [
	| editorModel path  |

	editorModel := aProjectEditor model.
	path := owner model findPathForProject: editorModel.
	path ifNil: [ ^ self ].

	owner selectPath: path
]
