Class {
	#name : 'PvViewEntry',
	#superclass : 'StEntry',
	#category : 'Perspective-Spotter-Model-Entry',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Entry'
}

{ #category : 'converting' }
PvViewEntry >> asString [ 

	^ content presenter spotterTitle
]

{ #category : 'evaluating' }
PvViewEntry >> doEvaluate [ 

	content takeKeyboardFocus
]

{ #category : 'accessing' }
PvViewEntry >> icon [
	
	^ content headerBar image
]

{ #category : 'accessing' }
PvViewEntry >> iconName [
	
	"I do not use this since the icon is already included in the view"
	^ nil 
]

{ #category : 'accessing' }
PvViewEntry >> iconOn: anIconProvider [

	^ self icon
]
