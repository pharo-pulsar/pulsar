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

{ #category : 'private' }
PulsarMethodSourceModel >> embeddedTextNodeIn: aMethodNode [
	"Answer the node holding the embedded document (an f-string or a string
	literal) inside the method body. Pragma arguments are intentionally excluded."

	| bodyNodes |
	bodyNodes := aMethodNode body withAllChildren.
	^ (bodyNodes detect: [ :each | each isKindOf: OCFStringNode ] ifNone: [ nil ]) ifNil: [
		  bodyNodes detect: [ :each | (each isKindOf: OCLiteralValueNode) and: [ each isString ] ] ifNone: [ nil ] ]
]

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
PulsarMethodSourceModel >> newFStringNodeFor: aString [
	"Answer an f-string node containing aString as raw source text.
	Answer nil if the text cannot be scanned as an f-string body."

	| quote source token parser |
	quote := String with: $'.
	source := 'f' , quote , aString , quote.
	token := (OCFStringScanner on: (ReadStream on: source)) next.
	(token isKindOf: OCFStringToken) ifFalse: [ ^ nil ].

	parser := OCFStringParser new.
	parser initializeParserWith: source from: 1 to: source size.
	^ parser parseFStringToken: token
]

{ #category : 'updating' }
PulsarMethodSourceModel >> newSourceFor: aString [
	"Answer my method source with the embedded document replaced by aString.
	The replacement is done over the AST, so pragmas, comments and any other
	part of the method are preserved."
	| methodNode targetNode newNode |
	
	methodNode := self entity ast copy.
	targetNode := self embeddedTextNodeIn: methodNode.
	targetNode ifNil: [ ^ nil ].

	newNode := self 
		replacementNodeFor: (aString escapeCharacter: $') 
		replacing: targetNode.
	newNode ifNil: [ ^ nil ].

	targetNode parent replaceNode: targetNode withNode: newNode.
	^ methodNode formattedCode
]

{ #category : 'private' }
PulsarMethodSourceModel >> pragma [

	^ self entity pragmaAt: #pulsarSourceEditor:
]

{ #category : 'accessing - ui' }
PulsarMethodSourceModel >> pulsarEditorClass [

	^ PulsarMethodSourceEditor
]

{ #category : 'private' }
PulsarMethodSourceModel >> replacementNodeFor: aString replacing: aNode [
	"Answer a node holding aString as the new embedded document, keeping the
	kind of literal of aNode."

	(aNode isKindOf: OCFStringNode) ifTrue: [ ^ self newFStringNodeFor: aString ].

	^ OCLiteralValueNode value: aString
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

	| newSource |
	newSource := self newSourceFor: aString.
	newSource ifNil: [ ^ false ].

	^ self updateWith: newSource notifying: (SpCodeMethodInteractionModel on: self entity)
]

{ #category : 'accessing' }
PulsarMethodSourceModel >> windowTitle [

	^ self pragma arguments first capitalized
]
