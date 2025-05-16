Class {
	#name : 'DockPanelEntry',
	#superclass : 'StEntry',
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'visiting' }
DockPanelEntry >> accept: aSpotter [

	aSpotter visitPanelEntry: self
]

{ #category : 'converting' }
DockPanelEntry >> asString [
	
	^ content presenter model fullName
]

{ #category : 'as yet unclassified' }
DockPanelEntry >> categoryLabel [

	^ 'editor'
]

{ #category : 'evaluating' }
DockPanelEntry >> doEvaluate [

	[ content raiseAndTakeKeyboardFocus ] fork
]

{ #category : 'accessing' }
DockPanelEntry >> iconName [

	^ nil
]
