"
I represent a method editor that adds extra tabs to the usual source editor when the edited method requests them.

## Responsibility

I show the method source together with the additional editors declared by the method's `<pulsarMethodEditor>` pragmas. I choose between the plain default layout and a tabbed layout depending on whether the model reports extra editors. I keep the active layout in sync as the edited method changes.

## Collaborators

- `PvMethodModel`: provides `extraEditors` and the editor classes and window titles for each tab.
- `PulsarMethodEditor`: supplies the base source editor, toolbar, and search bar that I reuse.
- Extra editor models such as `PulsarFFIModel`, `PulsarMethodSourceModel`, and `PulsarMethodTableModel`: each fills one additional tab.

## Public API and Key Messages

- `updateLayout`: switches to the tabbed layout when extra editors exist and back to the default layout when they disappear.
- `appendExtraEditors:`: adds one tab per extra editor model.
- Instances are created by the browser with `instantiate:on:`.

## Example

```smalltalk
aBrowser instantiate: PulsarTabbedMethodEditor on: aPvMethodModel
```

`PvMethodModel>>pulsarEditorClass` returns me, so opening a method from Pulsar's browser normally selects this editor automatically.
"
Class {
	#name : 'PulsarTabbedMethodEditor',
	#superclass : 'PulsarMethodEditor',
	#instVars : [
		'usingLayout',
		'tabbedLayout'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'private' }
PulsarTabbedMethodEditor >> appendExtraEditors: models [

	models do: [ :each | 
		| extraEditor |
		extraEditor := self instantiate: each pulsarEditorClass on: each.
		extraEditor notificationCenter: self notificationCenter.
		self layout children second 
			add: extraEditor
			label: each windowTitle ]
]

{ #category : 'testing' }
PulsarTabbedMethodEditor >> isUsingTabLayout [

	^ usingLayout = self tabbedLayout
]

{ #category : 'private' }
PulsarTabbedMethodEditor >> tabLayout [

	"this is weak, but no need to use a new variable for it (at the moment)"
	^ self isUsingTabLayout
		ifTrue: [ tabbedLayout children second ]
		ifFalse: [ nil ]
]

{ #category : 'layout' }
PulsarTabbedMethodEditor >> tabbedLayout [

	^ tabbedLayout ifNil: [ 
		tabbedLayout := SpBoxLayout newVertical
			add: toolbarPresenter expand: false;
			add: (SpTabLayout new
				add: (self editorOverlayLayout
						child: editorPresenter;
						yourself)
					label: 'Source';
				yourself);
			add: searchBarPresenter expand: false;
			yourself ]
]

{ #category : 'private - updating' }
PulsarTabbedMethodEditor >> updateAfterSubmit: result [

	super updateAfterSubmit: result.
	result ifTrue: [
		self updateLayout ]
]

{ #category : 'private - updating' }
PulsarTabbedMethodEditor >> updateEditor [

	super updateEditor.
	self updateLayout
]

{ #category : 'private - updating' }
PulsarTabbedMethodEditor >> updateLayout [

	"I'll check if I need to switch layout"
	self model extraEditors
		ifNotEmpty: [ :models |
			(usingLayout ~= self tabbedLayout) ifTrue: [ 
				self application defer: [ 
					self layout: self tabbedLayout.
					self appendExtraEditors: models ] ] ]
		ifEmpty: [
			(usingLayout = self tabbedLayout) ifTrue: [ 
				self application defer: [ 
					self layout: self defaultLayout ].
				tabbedLayout := nil ] ].

	usingLayout := self layout
]

{ #category : 'private - updating' }
PulsarTabbedMethodEditor >> updateModelEntityWith: anEntity [

	super updateModelEntityWith: anEntity.
	
	self isUsingTabLayout ifFalse: [ ^ self ].
	
	self tabLayout children do: [ :each |
		each isSpLayout 
			ifFalse: [ each model entity: anEntity ] ]
]

{ #category : 'private - updating' }
PulsarTabbedMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	super updatePresenter
]

{ #category : 'accessing' }
PulsarTabbedMethodEditor >> usingLayout [

	^ usingLayout ifNil: [ usingLayout := self layout ]
]
