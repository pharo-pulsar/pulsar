Extension { #name : 'SpCodeMethodInteractionModel' }

{ #category : '*Pulsar-Browser' }
SpCodeMethodInteractionModel >> informError: aCompilationError [
	| errors |

	errors := aCompilationError compilationResult ast withAllChildren select: #isError.
	errors do: [ :each | 
		self owner addTextSegmentDecoration: (SpTextPresenterDecorator forError
			interval: (each start to: each stop);
			title: (each isParseError 
				ifTrue: [ 'Parse error: {1}' format: { each errorMessage } ]
				ifFalse: [ each asString ]);
			yourself) ]
]
