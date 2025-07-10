"
A micro tool to explore the complete tree of a an instance (it can be used to have a quick view of a complete structure) 
"
Class {
	#name : 'DockObjectExplorer',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'treePresenter',
		'entriesAlreadyVisited'
	],
	#category : 'Dock-Tool-ObjectExplorer',
	#package : 'Dock-Tool-ObjectExplorer'
}

{ #category : 'layout' }
DockObjectExplorer >> defaultLayout [

	^ SpBoxLayout newVertical
		add: treePresenter;
		yourself
]

{ #category : 'initialization' }
DockObjectExplorer >> initializePresenters [

	treePresenter := self newEasyTreeColumnView
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #label);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		children: [ :anExplorerEntry | anExplorerEntry children ];
		yourself
	
]

{ #category : 'initialization' }
DockObjectExplorer >> removeAlreadyVisitedEntriesOf: aCollection [
	| entries |

	entries := aCollection \ entriesAlreadyVisited.
	entriesAlreadyVisited addAll: entries.
	^entries
]

{ #category : 'initialization' }
DockObjectExplorer >> updatePresenter [

	self model ifNil: [ ^ self ].
	treePresenter roots: { self model }.
	treePresenter expandAll
]
