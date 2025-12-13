Class {
	#name : 'DockRequestTextDialog',
	#superclass : 'DockRequestDialog',
	#category : 'Dock-Browser-Application',
	#package : 'Dock-Browser',
	#tag : 'Application'
}

{ #category : 'accessing' }
DockRequestTextDialog class >> defaultPreferredExtent [

	^ 600@400
]

{ #category : 'layout' }
DockRequestTextDialog >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newHorizontal
			hAlignCenter;
			add: titlePresenter;
			yourself)
			expand: false;
		add: label expand: false;
		add: textInput;
		add: errorLabel expand: false;
		add: responseAreaPresenter expand: false; 
		yourself
]

{ #category : 'initialization' }
DockRequestTextDialog >> initializePresenters [

	super initializePresenters.
	textInput := self newText
]
