Class {
	#name : #PvOutlineClassModel,
	#superclass : #PvClassModel,
	#category : #'Perspective-Class-Model'
}

{ #category : #'accessing - announcement' }
PvOutlineClassModel >> activatedAnnouncementClass [
	
	^ PvOutlineClassActivatedAnnouncement
]

{ #category : #accessing }
PvOutlineClassModel >> children [

	^ { PvEntityTreeNode newName: 'Shared Variables' children: self collectClassSharedVariables },
	  { PvEntityTreeNode newName: 'Class Slots' children: self collectClassVariables },
	  { PvEntityTreeNode newName: 'Slots'children: self collectVariables }, 
	  { PvEntityTreeNode newName: 'Class Methods' children: self collectClassMethods },  
	  self collectMethods
]

{ #category : #private }
PvOutlineClassModel >> collectClassMethods [
	
	^ (self entity classSide methods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : #private }
PvOutlineClassModel >> collectClassSharedVariables [
	
	^ #()
]

{ #category : #private }
PvOutlineClassModel >> collectClassVariables [
		
	^ self entity classSide slots 
		collect: [ :each | PvSlotModel newEnvironment: self environmentModel entity: each ]
]

{ #category : #private }
PvOutlineClassModel >> collectMethods [
	
	^ (self entity instanceSide methods 
		collect: [ :each | PvMethodModel newEnvironment: self environmentModel entity: each ])
		sorted: #name ascending
]

{ #category : #private }
PvOutlineClassModel >> collectVariables [
	
	^ self entity instanceSide slots 
		collect: [ :each | PvSlotModel newEnvironment: self entity: each ]
]

{ #category : #accessing }
PvOutlineClassModel >> iconName [

	^ self entity systemIconName
]

{ #category : #accessing }
PvOutlineClassModel >> name [

	^ self entity name
]
