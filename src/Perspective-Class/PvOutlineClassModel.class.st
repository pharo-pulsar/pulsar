Class {
	#name : 'PvOutlineClassModel',
	#superclass : 'PvClassModel',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'accessing' }
PvOutlineClassModel >> children [

	^ { PvTreeNodeModel newName: 'Shared Variables' children: self collectClassSharedVariables },
	  { PvTreeNodeModel newName: 'Class Slots' children: self collectClassVariables },
	  { PvTreeNodeModel newName: 'Slots'children: self collectVariables }, 
	  { PvTreeNodeModel newName: 'Class Methods' children: self collectClassMethods },  
	  self collectMethods
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectClassMethods [
	
	"I need to use visibleMethods here because otherwise it will show TraitedClass methods"
	^ (self entity classSide visibleMethods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectClassMethodsForProtocol: aProtocol [

	^ (aProtocol methods
		collect: [ :each |
			PvMethodModel 
				newEnvironment: self environmentModel 
				entity: each ])
		sorted: [ :a | a selector ] ascending
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectClassProtocols [
	
	^ self collectProtocolsOn: self entity classSide
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectClassSharedVariables [
	
	^ self entity classSide classPool keys
		collect: [ :each | 
			PvSharedVaribleModel
				newEnvironment: self environmentModel 
				entity: self entity classSide
				name: each ]
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectClassVariables [
		
	^ (self entity classSide slots 
		collect: [ :each | PvSlotModel newEnvironment: self environmentModel entity: each ])
		copyWithFirst: (PulsarNoneVirtualSlot newEntity: self entity classSide)
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectMethods [
	
	^ (self entity instanceSide methods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectMethodsForProtocol: aProtocol [

	^ aProtocol methods
		select: [ :each | (self entity instanceSide methodDict includesKey: each selector) ] 
		thenCollect: [ :each | 
			PvMethodModel 
				newEnvironment: self environmentModel 
				entity: each ]
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectProtocols [
	
	^ self collectProtocolsOn: self entity instanceSide
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectProtocolsOn: aClassOrMetaclass [
	
	^ Array streamContents: [ :stream |
		"all methods"
		stream nextPut: (PulsarAllMethodsVirtualProtocol newEntity: aClassOrMetaclass).
		"virtual protocols (add listing here)"
		self virtualProtocolClasses do: [ :eachClass | 
			| virtualProtocol |
			virtualProtocol := eachClass newEntity: aClassOrMetaclass.
			virtualProtocol shouldBeDisplayed
				ifTrue: [ stream nextPut: virtualProtocol ] ].
		"trait methods"
		self entity traits do: [ :each |
			stream nextPut: (PulsarTraitMethodsVirtualProtocol 
				newEntity: aClassOrMetaclass 
				trait: each) ].
		"protocol methods"
		stream nextPutAll: (((aClassOrMetaclass protocols 
			collect: [ :each | PvProtocolModel newEnvironment: self environmentModel entity: each ])
			reject: #isEmpty)
			sorted: #name ascending) ]
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectTraitUsers [
	
	^ self entity users 
		collect: [ :eachClass | 
			PvClassModel 
				newEnvironment: self environmentModel
				entity: eachClass ]
		as: Array
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectVariables [
	
	^ (self entity instanceSide slots
		collect: [ :each | PvSlotModel newEnvironment: self entity: each ])
		copyWithFirst: (PulsarNoneVirtualSlot newEntity: self entity instanceSide)
]

{ #category : 'accessing' }
PvOutlineClassModel >> iconName [

	^ self entity systemIconName
]

{ #category : 'accessing' }
PvOutlineClassModel >> name [

	^ self entity name
]

{ #category : 'private' }
PvOutlineClassModel >> species [

	^ PvClassModel
]

{ #category : 'accessing - filtering' }
PvOutlineClassModel >> toggleFilterByProtocol: aProtocol [

	self halt
]

{ #category : 'private' }
PvOutlineClassModel >> virtualProtocolClasses [

	^ { PulsarUndeclaredMethodsVirtualProtocol }
]
