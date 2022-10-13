Class {
	#name : #PvPharoGtkConfiguration,
	#superclass : #LnPharoGtkConfiguration,
	#category : #'Perspective-Application'
}

{ #category : #configuring }
PvPharoGtkConfiguration >> configureGeneral: anApplication [

	super configureGeneral: anApplication.
	self addCSSProviderFromString: '
.link { padding: 0px }
.cell-link { font-size: smaller; font-weight: normal; color: gray; min-width: 10px }
.pvEditorScrollBar { min-height: 150px }
.pvNavigation { min-width: 450px; min-height: 350px; padding: 5px }
/* .pvNavigation treeview.view { background-color: transparent } */
button.pvProtocol { font-weight: normal }
.pvProtocolChooser { min-width: 200px; min-height: 280px }
'
]

{ #category : #initialization }
PvPharoGtkConfiguration >> initialize [

	super initialize.
	self theme: LnLightTheme new
]
