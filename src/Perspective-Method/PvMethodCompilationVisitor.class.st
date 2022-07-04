Class {
	#name : #PvMethodCompilationVisitor,
	#superclass : #Object,
	#category : #'Perspective-Method-Model'
}

{ #category : #visiting }
PvMethodCompilationVisitor >> visitUndeclaredVariableWarning: aWarning [

	^ aWarning declareUndefined
]
