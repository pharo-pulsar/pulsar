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
	
	^ (self entity classSide methods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectClassMethodsForProtocol: aProtocol [

	^ aProtocol selectors sorted 
		collect: [ :each |
			PvMethodModel 
				newEnvironment: self environmentModel 
				entity: (self entity classSide methodDict at: each) ]
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectClassProtocols [
	
	^ ((self entity classSide protocols 
		collect: [ :each | PvProtocolModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending)
		copyWithFirst: (DockAllMethodsVirtualProtocol newEntity: self entity classSide)
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
		copyWithFirst: (DockNoneVirtualSlot newEntity: self entity classSide)
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectMethods [
	
	^ (self entity instanceSide methods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectMethodsForProtocol: aProtocol [

	^ aProtocol selectors sorted
		collect: [ :each | 
			PvMethodModel 
				newEnvironment: self environmentModel 
				entity: (self entity instanceSide methodDict at: each) ]
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectProtocols [
	
	^ ((self entity instanceSide protocols 
		collect: [ :each | PvProtocolModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending)
		copyWithFirst: (DockAllMethodsVirtualProtocol newEntity: self entity instanceSide)
]

{ #category : 'accessing - collecting' }
PvOutlineClassModel >> collectVariables [
	
	^ (self entity instanceSide slots
		collect: [ :each | PvSlotModel newEnvironment: self entity: each ])
		copyWithFirst: (DockNoneVirtualSlot newEntity: self entity instanceSide)
]

{ #category : 'accessing' }
PvOutlineClassModel >> iconName [

	^ self entity systemIconName
]

{ #category : 'accessing' }
PvOutlineClassModel >> name [

	^ self entity name
]

{ #category : 'accessing - filtering' }
PvOutlineClassModel >> toggleFilterByProtocol: aProtocol [

	self halt
]
