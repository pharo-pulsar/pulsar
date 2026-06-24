Class {
	#name : 'PulsarBaselineMapBuilder',
	#superclass : 'RSThemedMapBuilder',
	#instVars : [
		'isDarkTheme'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'colors' }
PulsarBaselineMapBuilder class >> darkColors [

	self flag: #TODO. "This has to come from a configuration, but for now we are fine"
	^ Dictionary new
		  at: #backgroundColor 	put: (Color fromHexString: '1d1d20');
		  at: #selectionColor 	put: (Color fromHexString: '3584e4');
		  at: #textColor 		put: Color white;
		  at: #dangerTextColor 	put: (Color fromHexString: 'ff5555');
		  yourself
]

{ #category : 'colors' }
PulsarBaselineMapBuilder class >> lightColors [

	self flag: #TODO. "This has to come from a configuration, but for now we are fine"
	^ Dictionary new
		  at: #backgroundColor 	put: Color white;
		  at: #selectionColor 	put: (Color fromHexString: '3584e4');
		  at: #textColor 		put: Color black;
		  at: #dangerTextColor 	put: Color red;
		  yourself
]

{ #category : 'accessing' }
PulsarBaselineMapBuilder >> backgroundColor [

	^ self colors at: #backgroundColor
]

{ #category : 'accessing' }
PulsarBaselineMapBuilder >> colors [

	^ isDarkTheme
		  ifTrue: [ self class darkColors ]
		  ifFalse: [ self class lightColors ]
]

{ #category : 'accessing' }
PulsarBaselineMapBuilder >> dangerTextColor [

	^ self colors at: #dangerTextColor
]

{ #category : 'accessing' }
PulsarBaselineMapBuilder >> isDarkTheme [

	^ isDarkTheme
]

{ #category : 'accessing' }
PulsarBaselineMapBuilder >> isDarkTheme: aBoolean [

	isDarkTheme := aBoolean
]

{ #category : 'accessing' }
PulsarBaselineMapBuilder >> selectionColor [

	^ self colors at: #selectionColor
]

{ #category : 'accessing' }
PulsarBaselineMapBuilder >> textColor [

	^ self colors at: #textColor
]

{ #category : 'accessing - defaults' }
PulsarBaselineMapBuilder >> theme [

	^ self
]
