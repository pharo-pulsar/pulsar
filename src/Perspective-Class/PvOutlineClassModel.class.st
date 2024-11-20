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

{ #category : 'private' }
PvOutlineClassModel >> collectClassMethods [
	
	^ (self entity classSide methods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : 'private' }
PvOutlineClassModel >> collectClassSharedVariables [
	
	^ #()
]

{ #category : 'private' }
PvOutlineClassModel >> collectClassVariables [
		
	^ self entity classSide slots 
		collect: [ :each | PvSlotModel newEnvironment: self environmentModel entity: each ]
]

{ #category : 'private' }
PvOutlineClassModel >> collectMethods [
	
	^ (self entity instanceSide methods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : 'private' }
PvOutlineClassModel >> collectVariables [
	
	^ self entity instanceSide slots 
		collect: [ :each | PvSlotModel newEnvironment: self entity: each ]
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
