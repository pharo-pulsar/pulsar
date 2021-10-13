Class {
	#name : #StBrowserClassDefinitionPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'codePresenter'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserClassDefinitionPresenter class >> type [

	^ #class
]

{ #category : #adding }
StBrowserClassDefinitionPresenter >> addToNotebook: aNotebook [

	aNotebook addPage: (StBrowserEditorPage new   
		title: self model shortName;
		icon: (self application iconNamed: self model windowIconName);
		editor: self;
		beCloseable;
		yourself)
]

{ #category : #initialization }
StBrowserClassDefinitionPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (codePresenter := self newCode);
		yourself).
		
	codePresenter beForScripting
]

{ #category : #testing }
StBrowserClassDefinitionPresenter >> isClassDefinitionEditor [

	^ true
]

{ #category : #testing }
StBrowserClassDefinitionPresenter >> isClassEditor [

	^ true
]

{ #category : #accessing }
StBrowserClassDefinitionPresenter >> tabPriority [

	^ 55
]

{ #category : #adding }
StBrowserClassDefinitionPresenter >> updateNotebookPage: aPage [

	aPage 
		title: self model shortName;
		icon: (self application iconNamed: self model windowIconName)
]

{ #category : #initialization }
StBrowserClassDefinitionPresenter >> updatePresenter [

	codePresenter text: self model classDefinition
]
