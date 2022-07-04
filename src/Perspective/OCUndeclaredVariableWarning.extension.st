Extension { #name : #OCUndeclaredVariableWarning }

{ #category : #'*Perspective' }
OCUndeclaredVariableWarning >> accept: aVisitor [

	^ aVisitor visitUndeclaredVariableWarning: self
]
