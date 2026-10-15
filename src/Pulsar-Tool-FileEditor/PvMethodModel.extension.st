Extension { #name : 'PvMethodModel' }

{ #category : '*Pulsar-Tool-FileEditor' }
PvMethodModel >> editorFFI: aCollection [

	<pulsarMethodEditor>
	self ffiCallArrayNode ifNil: [ ^ self ].
	aCollection add: (PulsarFFIModel newEnvironment: self environmentModel entity: self entity)
]

{ #category : '*Pulsar-Tool-FileEditor' }
PvMethodModel >> editorSource: aCollection [
	<pulsarMethodEditor>
	
	(self entity hasPragmaNamed: #pulsarSourceEditor:) ifFalse: [ ^ self ].
	aCollection add: (
		PulsarMethodSourceModel 
			newEnvironment: self environmentModel 
			entity: self entity)
]

{ #category : '*Pulsar-Tool-FileEditor' }
PvMethodModel >> editorTable: aCollection [

	<pulsarMethodEditor>
	(self entity hasPragmaNamed: #pulsarTableEditor:) ifFalse: [ ^ self ].
	aCollection add: (PulsarMethodTableModel newEnvironment: self environmentModel entity: self entity)
]

{ #category : '*Pulsar-Tool-FileEditor' }
PvMethodModel >> ffiCallArrayNode [
	"Answer the literal array node that is the first argument of a single ffiCall: family send in this method, or nil if the method is not a simple FFI call."
	| body statement send firstArgument ast |
	
	ast := self entity ast.
	ast ifNil: [ ^ nil ].
	
	body := self entity ast body.
	body statements size = 1 ifFalse: [ ^ nil ].
	statement := body statements first.
	send := (statement isKindOf: OCMessageNode)
		        ifTrue: [ statement ]
		        ifFalse: [
				        (statement isKindOf: OCReturnNode)
					        ifTrue: [ statement value ]
					        ifFalse: [ nil ] ].
	(send isKindOf: OCMessageNode) ifFalse: [ ^ nil ].
	(send selector beginsWith: 'ffiCall:') ifFalse: [ ^ nil ].
	firstArgument := send arguments first.
	^ (firstArgument isKindOf: OCLiteralArrayNode)
		  ifTrue: [ firstArgument ]
		  ifFalse: [ nil ]
]
