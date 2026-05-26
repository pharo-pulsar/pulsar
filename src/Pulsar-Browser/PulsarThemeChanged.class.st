Class {
	#name : 'PulsarThemeChanged',
	#superclass : 'Announcement',
	#instVars : [
		'isDark'
	],
	#category : 'Pulsar-Browser-Announcement',
	#package : 'Pulsar-Browser',
	#tag : 'Announcement'
}

{ #category : 'testing' }
PulsarThemeChanged >> isDark [

	^ isDark
]

{ #category : 'accessing' }
PulsarThemeChanged >> isDark: aBoolean [

	isDark := aBoolean
]
