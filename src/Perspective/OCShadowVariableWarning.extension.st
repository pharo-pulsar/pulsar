Extension { #name : #OCShadowVariableWarning }

{ #category : #'*Perspective' }
OCShadowVariableWarning >> accept: aVisitor [

	^ aVisitor visitShadowVariableWarning: self
]
