Class {
	#name : #PvPharoApplication,
	#superclass : #LnPharoApplication,
	#instVars : [
		'name'
	],
	#category : #'Perspective-Application'
}

{ #category : #'private - factory' }
PvPharoApplication >> newIconProvider [

	^ (PvLocationWithThemeIconProvider new
			application: self;
			addLocation: './new-icons' asFileReference;
			addLocation: './idea-community-icons' asFileReference;
			yourself),
	  StPharoDefaultIconProvider new, 
	  SgaGtkThemeIconProvider new,
	  PvDefaultIconProvider new
]
