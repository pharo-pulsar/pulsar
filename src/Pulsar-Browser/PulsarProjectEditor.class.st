Class {
	#name : 'PulsarProjectEditor',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTEditor',
	#classTraits : 'PulsarTEditor classTrait',
	#instVars : [
		'baselineMapPresenter',
		'dependenciesPresenter'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'api - focus' }
PulsarProjectEditor >> defaultKeyboardFocus [

	^ dependenciesPresenter
]

{ #category : 'layout' }
PulsarProjectEditor >> defaultLayout [

	^ SpTabLayout new
		  add: baselineMapPresenter label: 'Baseline Map';
		  add: dependenciesPresenter label: 'Dependencies';
		  yourself
]

{ #category : 'initialization' }
PulsarProjectEditor >> initializePresenters [

	self addStyle: 'pulsarProjectEditor'.

	baselineMapPresenter := self instantiate: PulsarProjectBaselineMapPresenter.

	dependenciesPresenter := self 
		instantiate: PulsarProjectDependenciesPresenter
		on: self model
]

{ #category : 'initialization' }
PulsarProjectEditor >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self model name;
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'initialization' }
PulsarProjectEditor >> notifyEditorActivated [

	self notificationCenter announce: (PulsarEditorActivated newValue: self)
]

{ #category : 'initialization' }
PulsarProjectEditor >> updatePresenter [

	dependenciesPresenter updatePresenter.
	self model isVolatileProject
		ifFalse: [ baselineMapPresenter baselineClass: self model entity ].

	self withPanelWidgetDo: [ :aWindow | aWindow title: self model name ]
]
