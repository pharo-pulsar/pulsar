Extension { #name : #RPackageTag }

{ #category : #'*Perspective' }
RPackageTag >> classDefinitionString [
	
	self isRoot ifTrue: [ ^ self package classDefinitionString ].
	
	^ FluidClassDefinitionPrinter new 
		classDefinitionTemplateInPackage: self package name
		tag: self name
]
