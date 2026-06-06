"
A tree view panel that displays a directory structure for the Pulsar browser.

It shows directories and files in a tree, allowing navigation through the file system. Directories can be expanded to reveal their contents, and files can be activated to open them in a PulsarFileEditor.
"
Class {
	#name : 'PulsarDirectoryView',
	#superclass : 'PulsarCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'accessing' }
PulsarDirectoryView class >> defaultPanelPosition [

	^ SpPanelPosition startArea
		row: 1;
		yourself
]

{ #category : 'layout' }
PulsarDirectoryView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'private - actions' }
PulsarDirectoryView >> doClose [

	self withNearWindowLikeDo: [ :aWindow | aWindow close ]
]

{ #category : 'initialization' }
PulsarDirectoryView >> initializePresenters [

	self addStyle: 'pulsarDirectoryView'.
	
	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter addPresenter: (self newToolbar 
		beIcons; 
		add: (self newButton
			addStyle: 'flat';
			icon: (self iconNamed: 'close');
			help: 'Close critics console';
			action: [ self doClose ];
			yourself);
		yourself).
		
	listPresenter := self newEasyTreeListView
		addStyle: 'stTree';
		children: [ :aModel | aModel children ];
		display: [ :aModel | aModel name ];
		displayIcon: [ :aModel | self iconNamed: aModel iconName ];
		yourself
]

{ #category : 'initialization' }
PulsarDirectoryView >> updatePresenter [

	self model ifNil: [ ^ self ].

	listPresenter roots: self model children
]
