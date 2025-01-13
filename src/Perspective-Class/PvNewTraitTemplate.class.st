Class {
	#name : 'PvNewTraitTemplate',
	#superclass : 'PvNewClassTemplate',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'helpers' }
PvNewTraitTemplate >> classDefinitionString [

	^ self parentModel traitDefinitionString
]

{ #category : 'accessing' }
PvNewTraitTemplate >> name [
	
	^ 'New trait'
]
