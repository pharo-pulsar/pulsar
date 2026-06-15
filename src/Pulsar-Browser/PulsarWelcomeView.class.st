"
This is an onboarding window
"
Class {
	#name : 'PulsarWelcomeView',
	#superclass : 'PulsarEditor',
	#instVars : [
		'contentPresenter'
	],
	#category : 'Pulsar-Browser-View-Welcome',
	#package : 'Pulsar-Browser',
	#tag : 'View-Welcome'
}

{ #category : 'initialization' }
PulsarWelcomeView >> connectPresenters [
	
]

{ #category : 'layout' }
PulsarWelcomeView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: contentPresenter;
		yourself
]

{ #category : 'events' }
PulsarWelcomeView >> eventModelRemoved: ann [

]

{ #category : 'events' }
PulsarWelcomeView >> eventSyntaxHighlightThemeChanged: ann [

	"contentPresenter syntaxHighlightTheme: self application syntaxHighlightTheme"
]

{ #category : 'events' }
PulsarWelcomeView >> eventThemeChanged: ann [

	contentPresenter styleScheme: self application styleScheme.
	self refreshIcons
]

{ #category : 'initialization' }
PulsarWelcomeView >> initialize [

	self setModelBeforeInitialization: PulsarWelcomeModel new.
	super initialize
]

{ #category : 'initialization' }
PulsarWelcomeView >> initializePresenters [

	contentPresenter :=  (self instantiate: SeEditorPresenter)
		addStyle: 'stCode';
		withHyperlinks;
		beNotEditable;
		yourself
]

{ #category : 'initialization' }
PulsarWelcomeView >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self model name;
		whenClosedDo: [ self notifyEditorClosed ]
]

{ #category : 'accessing - snapshot' }
PulsarWelcomeView >> snapshot [

	^ PulsarPanelSnapshot on: self
]

{ #category : 'initialization' }
PulsarWelcomeView >> updatePresenter [

	contentPresenter 
		styleScheme: self application styleScheme;
		language: 'markdown';		
		text: self model contents.
		
	self flag: #TODO. "Send this to the adapter"
	contentPresenter whenBuiltDo: [ :ann |
		contentPresenter withAdapterDo: [ :anAdapter |
			anAdapter innerWidgetDo: [ :w | 
				| iter anchor image |
				
				iter := w textBuffer iterAtOffset: 1.
				anchor := w textBuffer createChildAnchor: iter.
				image := GtkPicture newForFileName: (self application resourcesDir / 'logos' / 'pharo.png') fullName.
				image sizeRequest: 208@200.
				w addChild: image atAnchor: anchor.
				
				iter := w textBuffer iterAtOffset: 2.
				anchor := w textBuffer createChildAnchor: iter.
				image := GtkPicture newForFileName: (self application resourcesDir / 'logos' / 'pulsar.png') fullName.
				image sizeRequest: 180@200.
				w addChild: image atAnchor: anchor ] ] ]
]
