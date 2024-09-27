Class {
	#name : 'PvMethodCompilationVisitor',
	#superclass : 'Object',
	#category : 'Perspective-Method-Model',
	#package : 'Perspective-Method',
	#tag : 'Model'
}

{ #category : 'visiting' }
PvMethodCompilationVisitor >> visitUndeclaredVariableWarning: aWarning [

	^ aWarning declareUndefined
]
