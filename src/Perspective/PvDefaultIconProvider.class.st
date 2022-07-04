"
An icon provider that answer always a value (ThemeIcons current noIcon).
Used as terminal of the icon composite.
"
Class {
	#name : #PvDefaultIconProvider,
	#superclass : #SpIconProvider,
	#category : #'Perspective-Icon'
}

{ #category : #accessing }
PvDefaultIconProvider >> iconNamed: aName ifAbsent: aBlock [

	^ ThemeIcons current noIcon
]
