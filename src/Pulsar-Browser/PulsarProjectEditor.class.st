Class {
	#name : 'PulsarProjectEditor',
	#superclass : 'PulsarBaseView',
	#traits : 'PulsarTEditor',
	#classTraits : 'PulsarTEditor classTrait',
	#instVars : [
		'baselineMapPresenter',
		'dependenciesPresenter',
		'projectViewPresenter'
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
		  add: projectViewPresenter label: 'Packages';
		  add: dependenciesPresenter label: 'Dependencies';
		  yourself
]

{ #category : 'initialization' }
PulsarProjectEditor >> initializePresenters [

	self addStyle: 'pulsarProjectEditor'.

	baselineMapPresenter := self instantiate: PulsarProjectBaselineMapPresenter.

	projectViewPresenter := self instantiate: PulsarSingleProjectView on: self model.

	dependenciesPresenter := self instantiate: PulsarProjectDependenciesPresenter on: self model
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
PulsarProjectEditor >> registerToBrowser: aPulsarBrowser [

	super registerToBrowser: aPulsarBrowser.
	projectViewPresenter registerToBrowser: aPulsarBrowser
]

{ #category : 'updating' }
PulsarProjectEditor >> updatePresenter [

	projectViewPresenter updatePresenter.
	dependenciesPresenter updatePresenter.
	self model isVolatileProject ifFalse: [ baselineMapPresenter baselineClass: self model entity ].

	self withPanelWidgetDo: [ :aWindow | aWindow title: self model name ]
]
