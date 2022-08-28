Class {
	#name : #PvPharoGtkConfiguration,
	#superclass : #LnPharoGtkConfiguration,
	#category : #'Perspective-Application'
}

{ #category : #configuring }
PvPharoGtkConfiguration >> configureGeneral: anApplication [

	super configureGeneral: anApplication.
	self addCSSProviderFromString: '
.pvEditorScrollBar { min-height: 150px }	
	'
]

{ #category : #initialization }
PvPharoGtkConfiguration >> initialize [

	super initialize.
	self theme: LnLightTheme new
]
