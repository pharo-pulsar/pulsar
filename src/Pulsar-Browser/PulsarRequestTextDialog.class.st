Class {
	#name : 'PulsarRequestTextDialog',
	#superclass : 'PulsarRequestDialog',
	#category : 'Pulsar-Browser-Application',
	#package : 'Pulsar-Browser',
	#tag : 'Application'
}

{ #category : 'accessing' }
PulsarRequestTextDialog class >> defaultPreferredExtent [

	^ 600@400
]

{ #category : 'layout' }
PulsarRequestTextDialog >> defaultLayout [

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
PulsarRequestTextDialog >> initializePresenters [

	super initializePresenters.
	textInput := self newText
]
