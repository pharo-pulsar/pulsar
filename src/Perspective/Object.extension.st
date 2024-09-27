Extension { #name : 'Object' }

{ #category : '*Perspective' }
Object >> spotterProcessorsFor: aSpotterStep context: aSymbol [
	
	(Pragma allNamed: #spotterOrder:context: from: self class to: Object) 
		select: [ :each | (each argumentAt: 2) = aSymbol ]
		thenDo: [ :aPragma |
			self perform: aPragma methodSelector with: aSpotterStep.
			aSpotterStep processors 
				ifNotEmpty: [ :list | list last order: (aPragma argumentAt: 1) ] ]
]
