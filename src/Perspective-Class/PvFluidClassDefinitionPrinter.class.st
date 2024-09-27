Class {
	#name : 'PvFluidClassDefinitionPrinter',
	#superclass : 'FluidClassDefinitionPrinter',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PvFluidClassDefinitionPrinter class >> for: aClass [ 
	"Given the current class definition syntax and the need for the class, 
	return the correct printer. 
	We only print slots with the fluid class definition."
	
	^ self new
		for: aClass; 
		yourself
]

{ #category : 'instance creation' }
PvFluidClassDefinitionPrinter class >> new [

	^ self basicNew initialize
]

{ #category : 'helpers' }
PvFluidClassDefinitionPrinter >> classDefinitionString [

	^ String streamContents: [ :stream | 
		  forClass superclass
			  ifNotNil: [ stream nextPutAll: forClass superclass name ]
			  ifNil: [ stream nextPutAll: 'nil' ].
			
		  self msgAndClassNameOn: stream.
		  forClass classLayout isFixedLayout 
				ifFalse: [ self layoutOn: stream ].

			self traitsOn: stream.
			(self class displayEmptySlots or: [ forClass classSlots notEmpty ]) 
				ifTrue: [ self classSlotsOn: stream ].
		  	(self class displayEmptySlots or: [ forClass sharedVariables notEmpty ]) 
				ifTrue: [ self sharedVariablesOn: stream ].
			(self class displayEmptySlots or: [ forClass slots notEmpty ]) 
				ifTrue: [ self slotsOn: stream ].
			forClass sharedPools ifNotEmpty: [ self sharedPoolsOn: stream ].

			self tagOn: stream.
			self packageOn: stream ]
]

{ #category : 'accessing' }
PvFluidClassDefinitionPrinter >> classDefinitionTemplateInPackage: aPackageName tag: aTagName [

	^ String streamContents: [ :stream |
		stream
			<< 'Object << #MyClass' << String cr
			<< String tab << 'traits: {};' << String cr 
			<< String tab << 'slots: {};' << String cr
			<< String tab << 'classSlots: {};' << String cr
			<< String tab << 'sharedVariables: {};' << String cr
			<< String tab << 'sharedPools: {};' << String cr
			<< String tab << 'tag: ''' << (aTagName ifNil: [ '' ]) << ''';' << String cr
			<< String tab << 'package: ''' << aPackageName << '''' ]
]

{ #category : 'as yet unclassified' }
PvFluidClassDefinitionPrinter >> classSlotDefinitionsOn: aStream [
	"If the class has many instance variable print one slot per line, do the same for complex slots."
	| oneSlotPerLine localSlots |

	"We could have the heuristics based on the sum of the slot name character length."
	oneSlotPerLine := false.
	localSlots := forClass class localSlots.
	( localSlots size > 8 or: [ localSlots anySatisfy: [ :s | s needsFullDefinition ]]) 
		ifTrue: [ localSlots size = 1 ifFalse: [ oneSlotPerLine := true ] ].
	aStream nextPutAll: '{'.
	"To start aligned really nice when we have two complex slots"
	oneSlotPerLine ifTrue: [ 
		self slotShiftOn: aStream ].
	localSlots
		do: [ :slot | 
			aStream space.
			aStream nextPutAll: slot definitionString.
			oneSlotPerLine := slot needsFullDefinition | oneSlotPerLine.
			aStream space ]
		separatedBy: [ 
			aStream nextPutAll: '.'.
			oneSlotPerLine ifTrue: [ self slotShiftOn: aStream ] ].
	aStream nextPutAll: '}'
]

{ #category : 'elementary operations' }
PvFluidClassDefinitionPrinter >> classSlotsOn: aStream [
	"uses: can the last part of a definition so watch out for terminating ;"
	
	aStream crtab.
	aStream nextPutAll: 'classSlots: '.
	self classSlotDefinitionsOn: aStream.
	aStream nextPutAll: ';'.
]

{ #category : 'public API' }
PvFluidClassDefinitionPrinter >> traitDefinitionString [

	^ String streamContents: [ :stream | 
			stream nextPutAll: 'Trait'.
			self msgAndClassNameOn: stream.
			self traitsOn: stream.
			
			(self class displayEmptySlots or: [ forClass classSlots notEmpty ]) 
				ifTrue: [ self classSlotsOn: stream ].
			(self class displayEmptySlots or: [ forClass slots notEmpty ]) 
				ifTrue: [ self slotsOn: stream ].
				
			self tagOn: stream.
			self packageOn: stream ]
]
