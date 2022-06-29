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

	^ (SpLocationIconProvider newLocation: './idea-community-icons' asFileReference),
	  StPharoDefaultIconProvider new, 
	  SgaGtkThemeIconProvider new,
	  PvDefaultIconProvider new
]
