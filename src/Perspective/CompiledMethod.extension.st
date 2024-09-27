Extension { #name : 'CompiledMethod' }

{ #category : '*Perspective' }
CompiledMethod >> hasFlag [
	
	^ self sendsAnySelectorOf: #(flag:)
]
