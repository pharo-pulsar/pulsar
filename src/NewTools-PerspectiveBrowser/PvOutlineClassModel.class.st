Class {
	#name : #PvOutlineClassModel,
	#superclass : #PvEntityModel,
	#category : #'NewTools-PerspectiveBrowser-View-Outline'
}

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
		collect: [ :each | PvMethodModel newEntity: each ])
		sorted: #name ascending
]

{ #category : #private }
PvOutlineClassModel >> collectClassSharedVariables [
	
	^ #()
]

{ #category : #private }
PvOutlineClassModel >> collectClassVariables [
		
	^ self entity classSide slots 
		collect: [ :each | PvSlotModel newEntity: each ]
]

{ #category : #private }
PvOutlineClassModel >> collectMethods [
	
	^ (self entity instanceSide methods 
		collect: [ :each | PvMethodModel newEntity: each ])
		sorted: #name ascending
]

{ #category : #private }
PvOutlineClassModel >> collectVariables [
	
	^ self entity instanceSide slots 
		collect: [ :each | PvSlotModel newEntity: each ]
]

{ #category : #accessing }
PvOutlineClassModel >> name [

	^ self entity name
]
