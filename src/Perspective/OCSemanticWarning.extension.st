Extension { #name : #OCSemanticWarning }

{ #category : #'*Perspective' }
OCSemanticWarning >> accept: aVisitor [

	^ aVisitor visitSemanticWarning: self
]
