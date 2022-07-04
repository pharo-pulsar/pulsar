Extension { #name : #FluidClassDefinitionPrinter }

{ #category : #'*Perspective' }
FluidClassDefinitionPrinter >> classDefinitionTemplateInPackage: aPackageName tag: aTagName [

	^ String streamContents: [ :stream |
		stream
			<< 'Object << #MyClass' << String cr
			<< String tab << 'traits: {};' << String cr 
			<< String tab << 'slots: {};' << String cr
			<< String tab << 'sharedVariables: {};' << String cr
			<< String tab << 'sharedPools: {};' << String cr
			<< String tab << 'tag: ''' << (aTagName ifNil: [ '' ]) << ''';' << String cr
			<< String tab << 'package: ''' << aPackageName << '''' ]
]
