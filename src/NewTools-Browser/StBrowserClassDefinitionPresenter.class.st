Class {
	#name : #StBrowserClassDefinitionPresenter,
	#superclass : #StBrowserEditorPresenter,
	#instVars : [
		'codePresenter',
		'code'
	],
	#category : #'NewTools-Browser-View'
}

{ #category : #accessing }
StBrowserClassDefinitionPresenter class >> type [

	^ #class
]

{ #category : #adding }
StBrowserClassDefinitionPresenter >> addToNotebook: aNotebook [

	aNotebook addPage: ((SpNotebookPage   
		title: self model shortName
		icon: (self application iconNamed: self model iconName) 
		provider: [ self ])
		beCloseable;
		yourself)
]

{ #category : #initialization }
StBrowserClassDefinitionPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
		add: (code := self newCode);
		yourself).
		
	code beForScripting
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
		icon: (self application iconNamed: self model iconName)
]

{ #category : #initialization }
StBrowserClassDefinitionPresenter >> updatePresenter [

	code text: self model classDefinition
]
