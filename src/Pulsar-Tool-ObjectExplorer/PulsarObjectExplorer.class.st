"
A micro tool to explore the complete tree of a an instance (it can be used to have a quick view of a complete structure).

Example: 
```smalltalk
app := SpApplication new useBackend: #Gtk.
explorer := PulsarObjectExplorer newApplication: app model: (PulsarObjectExplorerInstance newObject: yourObject).
explorer open.
```

"
Class {
	#name : 'PulsarObjectExplorer',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'treePresenter',
		'entriesAlreadyVisited'
	],
	#category : 'Pulsar-Tool-ObjectExplorer',
	#package : 'Pulsar-Tool-ObjectExplorer'
}

{ #category : 'layout' }
PulsarObjectExplorer >> defaultLayout [

	^ SpBoxLayout newVertical
		add: treePresenter;
		yourself
]

{ #category : 'initialization' }
PulsarObjectExplorer >> initializePresenters [

	treePresenter := self newEasyTreeColumnView
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #label);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: #value);
		children: [ :anExplorerEntry | anExplorerEntry children ];
		yourself
	
]

{ #category : 'initialization' }
PulsarObjectExplorer >> removeAlreadyVisitedEntriesOf: aCollection [
	| entries |

	entries := aCollection \ entriesAlreadyVisited.
	entriesAlreadyVisited addAll: entries.
	^entries
]

{ #category : 'initialization' }
PulsarObjectExplorer >> updatePresenter [

	self model ifNil: [ ^ self ].
	treePresenter roots: { self model }.
	treePresenter expandRoots
]
