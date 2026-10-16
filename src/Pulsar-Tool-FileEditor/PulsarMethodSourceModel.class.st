"
I represent a method whose body is an embedded text document (CSS, Markdown, JSON, ...) that should be edited as a file with syntax highlighting.

I exist so that a method decorated with the `<pulsarSourceEditor: 'FILETYPE'>` pragma can be edited in a dedicated source editor instead of the regular method editor. I extract the document from the method's string literal and write edits back into the method source.

My main collaborators are PvMethodModel, which holds my compiled-method entity and the pragma-driven extra-editor machinery, and PulsarMethodSourceEditor, the view I am edited through.

Public API and Key Messages

- `newEnvironment:entity:` to create an instance for a compiled method.
- `pulsarEditorClass` and `windowTitle` to resolve the editor and its tab label.
- `sourceCode` and `sourceCodeLanguage` to read the embedded document and its language.
- `updateWith:` to write edited text back and recompile the method.

Example: PulsarGtkConfiguration>>style is decorated with `<pulsarSourceEditor: 'css'>` and edited through this model.
"
Class {
	#name : 'PulsarMethodSourceModel',
	#superclass : 'PvMethodModel',
	#category : 'Pulsar-Tool-FileEditor-Model',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarMethodSourceModel >> fStringNode [
    "Answer the f-string node of my method, if any."
    ^ self entity ast
        withAllChildren
        detect: [ :node |
            (node respondsTo: #isFStringNode)
                and: [ node isFStringNode ] ]
        ifNone: [ nil ]
]

{ #category : 'testing' }
PulsarMethodSourceModel >> fileExists [

	^ true
]

{ #category : 'testing' }
PulsarMethodSourceModel >> isSmalltalk [

	self pragma arguments first = 'smalltalk'.
	
	^ false.
]

{ #category : 'private' }
PulsarMethodSourceModel >> pragma [

	^ self entity pragmaAt: #pulsarSourceEditor:
]

{ #category : 'accessing - ui' }
PulsarMethodSourceModel >> pulsarEditorClass [

	^ PulsarMethodSourceEditor
]

{ #category : 'accessing' }
PulsarMethodSourceModel >> sourceCode [

	^ self fStringNode
		ifNotNil: [ :fStringNode |
			fStringNode contentString ]
	  	ifNil: [ 
			self entity literals 
				detect: [ :each | each isString ] 
				ifNone: [ '' ] ].
]

{ #category : 'accessing' }
PulsarMethodSourceModel >> sourceCodeLanguage [

	^ self pragma arguments first
]

{ #category : 'updating' }
PulsarMethodSourceModel >> updateWith: aString [
	| escapedString |

	escapedString := aString escapeCharacter: $'.
	self 
		updateWith: f'[self selector]
	<pulsarSourceEditor: ''[self sourceCodeLanguage]''>

	^ ''[escapedString]'''
		notifying: (SpCodeMethodInteractionModel on: self entity).
		
	^ true
]

{ #category : 'accessing' }
PulsarMethodSourceModel >> windowTitle [

	^ self pragma arguments first capitalized
]
