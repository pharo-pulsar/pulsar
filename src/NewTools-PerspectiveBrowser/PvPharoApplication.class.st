Class {
	#name : #PvPharoApplication,
	#superclass : #LnPharoApplication,
	#instVars : [
		'name'
	],
	#category : #'NewTools-PerspectiveBrowser-Application'
}

{ #category : #'private - factory' }
PvPharoApplication >> newIconProvider [

	^ StPharoDefaultIconProvider new, 
	  SgaGtkThemeIconProvider new,
	  PvDefaultIconProvider new
]
