"
An editor to work with roassal visialisations.
"
Class {
	#name : 'PulsarRoassalEditor',
	#superclass : 'PulsarEditor',
	#instVars : [
		'roassalOverlayLayout',
		'roassalPresenter',
		'editorPanelPresenter'
	],
	#category : 'Pulsar-Tool-Roassal',
	#package : 'Pulsar-Tool-Roassal'
}

{ #category : 'initialization' }
PulsarRoassalEditor >> basicUpdateCanvas [

	roassalPresenter canvas: self model currentCanvas
]

{ #category : 'initialization' }
PulsarRoassalEditor >> canvasColor [

	self flag: #TODO. "Take this from a configuration"
	^ self application configuration isDarkTheme
		ifTrue: [ Color fromHexString: '1d1d20' ]
		ifFalse: [ Color white ]
]

{ #category : 'api - focus' }
PulsarRoassalEditor >> defaultKeyboardFocus [

	^ editorPresenter
]

{ #category : 'layout' }
PulsarRoassalEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newVertical
			add: ((roassalOverlayLayout := SpOverlayLayout new)
				child: (SpScrollableLayout with: roassalPresenter);
				yourself);
			add: ((editorPanelPresenter := self newPresenter)
				layout: (SpBoxLayout newVertical
					add: ((editorOverlayLayout := SpOverlayLayout new) 
						child: editorPresenter;
						yourself);
					add: searchBarPresenter expand: false;				
					yourself);
				yourself);
			yourself);
		yourself
]

{ #category : 'accessing - actions' }
PulsarRoassalEditor >> defineActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #editorActions with: [ :group | group
		priority: 1;
		name: 'Editor';
		beDisplayedAsGroup;
		addActionWith: [ :action | action 
			name: 'Toggle script';
			description: 'Toggle roassal script';
			iconName: 'panel-bottom';
			action: [ self doToggleScriptCommand: action ] ] ]
]

{ #category : 'actions' }
PulsarRoassalEditor >> doReset [

	super doReset.
	self installIconStyler
]

{ #category : 'actions' }
PulsarRoassalEditor >> doSubmit: aString [

	self updatingWhile: [
			super doSubmit: aString.
			self basicUpdateCanvas.
			self updateContentActions ].
	self installIconStyler
]

{ #category : 'private - actions' }
PulsarRoassalEditor >> doToggleScriptCommand: anAction [

	editorPanelPresenter visible: editorPanelPresenter isVisible not
]

{ #category : 'initialization' }
PulsarRoassalEditor >> editorToolbarActions [
	"no 'left side' actions on a roassal editor"
	
	^ SpActionGroup new 
]

{ #category : 'events' }
PulsarRoassalEditor >> eventThemeChanged: ann [ 

	super eventThemeChanged: ann.
	
]

{ #category : 'initialization' }
PulsarRoassalEditor >> initializePresenters [

	super initializePresenters.
	
	self addStyle: 'pulsarRoassalEditor'.
	
	roassalPresenter := self newRoassal
]

{ #category : 'private - updating' }
PulsarRoassalEditor >> installIconStyler [

	| method |
	method := self model entity.
	method ifNil: [ ^ self ].
	IconStyler withSpecStaticStyler styleText: editorPresenter withAst: method ast
]

{ #category : 'private - announcing' }
PulsarRoassalEditor >> notifyModelChangedFrom: oldModel to: newModel [

	"we do not annonuce metamodel changes"
]

{ #category : 'private' }
PulsarRoassalEditor >> originalContent [

	^ self model sourceCode
]

{ #category : 'private - updating' }
PulsarRoassalEditor >> updateEditor [

	editorPresenter
		interactionModel: self model interactionModel;
		text: self model sourceCode.
	self installIconStyler
]

{ #category : 'initialization' }
PulsarRoassalEditor >> updatePresenter [

	super updatePresenter.
	
	self updateEditor.
	self updateRoassal
]

{ #category : 'initialization' }
PulsarRoassalEditor >> updateRoassal [

	self model sourceCode isEmptyOrNil
		ifFalse: [ self model updateCanvas ].
	self basicUpdateCanvas
]
