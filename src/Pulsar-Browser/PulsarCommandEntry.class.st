"
I wrap a CmCommand for display in the spotter Commands tab.

I replace StWorldMenuEntry (which wrapped Morphic world menu items) with proper CmCommand support. My content is a CmCommand, and I store the parent group name for display context.
"
Class {
	#name : 'PulsarCommandEntry',
	#superclass : 'StEntry',
	#instVars : [
		'groupName'
	],
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'visiting' }
PulsarCommandEntry >> accept: aSpotter [

	aSpotter visitMenuEntry: self
]

{ #category : 'converting' }
PulsarCommandEntry >> asString [

	^ content name
]

{ #category : 'accessing' }
PulsarCommandEntry >> categoryLabel [

	^ groupName ifNil: [ 'command' ]
]

{ #category : 'evaluating' }
PulsarCommandEntry >> doEvaluate [

	content execute
]

{ #category : 'accessing' }
PulsarCommandEntry >> groupName [

	^ groupName
]

{ #category : 'accessing' }
PulsarCommandEntry >> groupName: aString [

	groupName := aString
]

{ #category : 'accessing' }
PulsarCommandEntry >> iconName [

	^ content iconName
]

{ #category : 'accessing' }
PulsarCommandEntry >> label [

	| description |
	description := content description.
	(description isEmptyOrNil or: [ description = CmCommand defaultDescription ]) ifTrue: [ ^ content name ].
	^ content name , ' — ' , description
]
