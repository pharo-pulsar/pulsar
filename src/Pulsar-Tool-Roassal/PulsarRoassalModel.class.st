Class {
	#name : 'PulsarRoassalModel',
	#superclass : 'Object',
	#traits : 'PulsarTEnvironmentModel + PulsarTModel + PulsarTModelSnapshot + PulsarTActionContainer',
	#classTraits : 'PulsarTEnvironmentModel classTrait + PulsarTModel classTrait + PulsarTModelSnapshot classTrait + PulsarTActionContainer classTrait',
	#instVars : [
		'currentCanvas',
		'sourceCode',
		'interactionModel'
	],
	#category : 'Pulsar-Tool-Roassal',
	#package : 'Pulsar-Tool-Roassal'
}

{ #category : 'accessing - actions' }
PulsarRoassalModel >> actionDecorators [

	^ SpActionGroup new
]

{ #category : 'private' }
PulsarRoassalModel >> basicCurrentCanvas [

	^ currentCanvas ifNil: [ 
		currentCanvas := WorkspaceVariable key: #canvas value: RSCanvas new ]
]

{ #category : 'accessing' }
PulsarRoassalModel >> currentCanvas [
		
	^ self basicCurrentCanvas value
]

{ #category : 'accessing' }
PulsarRoassalModel >> iconName [

	^ 'graph'
]

{ #category : 'accessing' }
PulsarRoassalModel >> interactionModel [

	^ interactionModel ifNil: [ 
		interactionModel := SpCodeScriptingInteractionModel new
			addBinding: self basicCurrentCanvas;
			yourself ]
]

{ #category : 'accessing' }
PulsarRoassalModel >> name [

	^ 'Roassal Graph'
]

{ #category : 'private' }
PulsarRoassalModel >> prepareForSnapshot [

	^ self copy reset
]

{ #category : 'accessing' }
PulsarRoassalModel >> reset [

	currentCanvas := nil.
	interactionModel := nil
]

{ #category : 'accessing' }
PulsarRoassalModel >> sourceCode [

	^ sourceCode ifNil: [ sourceCode := '' ]
]

{ #category : 'updating' }
PulsarRoassalModel >> updateCanvas [

	^ self 
		updateWith: self sourceCode 
		notifying: self interactionModel
]

{ #category : 'updating' }
PulsarRoassalModel >> updateWith: aString notifying: anInteractionModel [

	self 
		assert: anInteractionModel == self interactionModel 
		description: 'This is not the correct interaction model'.
		
	[
		"compile it"
		self basicCurrentCanvas value: RSCanvas new.
		anInteractionModel compiler 
			source: aString;
			requestor: anInteractionModel;
			permitUndeclared: true;
			evaluate.
		"update source code"
		sourceCode := aString ]
	on: OCUndeclaredVariableWarning 
	do: [ :w | w resume ].

 	^ true
]
