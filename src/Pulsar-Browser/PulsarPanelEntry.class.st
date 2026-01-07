Class {
	#name : 'PulsarPanelEntry',
	#superclass : 'StEntry',
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'visiting' }
PulsarPanelEntry >> accept: aSpotter [

	aSpotter visitPanelEntry: self
]

{ #category : 'converting' }
PulsarPanelEntry >> asString [
	
	^ content presenter model fullName
]

{ #category : 'as yet unclassified' }
PulsarPanelEntry >> categoryLabel [

	^ 'editor'
]

{ #category : 'evaluating' }
PulsarPanelEntry >> doEvaluate [

	[ content raiseAndTakeKeyboardFocus ] fork
]

{ #category : 'accessing' }
PulsarPanelEntry >> iconName [

	^ nil
]
