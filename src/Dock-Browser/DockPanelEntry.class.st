Class {
	#name : 'DockPanelEntry',
	#superclass : 'StEntry',
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'visiting' }
DockPanelEntry >> accept: aSpotter [

	aSpotter visitMenuEntry: self
]

{ #category : 'converting' }
DockPanelEntry >> asString [
	
	^ content presenter spotterTitle
]

{ #category : 'as yet unclassified' }
DockPanelEntry >> categoryLabel [

	^ 'editor'
]

{ #category : 'evaluating' }
DockPanelEntry >> doEvaluate [

	[ content presenter notifyEditorActivated ] fork
]

{ #category : 'accessing' }
DockPanelEntry >> iconName [

	^ nil
]
