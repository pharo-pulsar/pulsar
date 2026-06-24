Class {
	#name : 'PulsarProjectBaselineMapPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'roassalPresenter'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'accessing' }
PulsarProjectBaselineMapPresenter >> baselineClass: aBaselineClass [

	| builder canvas isDark |
	aBaselineClass ifNil: [ ^ self ].

	isDark := self application configuration isDarkTheme.
	builder := PulsarBaselineMapBuilder new.
	builder isDarkTheme: isDark.
	builder baseline: aBaselineClass.
	builder build.
	canvas := builder canvas.
	roassalPresenter canvas: canvas
]

{ #category : 'layout' }
PulsarProjectBaselineMapPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: roassalPresenter;
		  yourself
]

{ #category : 'initialization' }
PulsarProjectBaselineMapPresenter >> initializePresenters [

	roassalPresenter := self newRoassal
]
