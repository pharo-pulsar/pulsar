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

{ #category : 'initialization' }
PulsarTabbedMethodEditor >> appendExtraEditors: models [

	models do: [ :each | 
		| extraEditor |
		extraEditor := self instantiate: each pulsarEditorClass on: each.
		extraEditor notificationCenter: self notificationCenter.
		self layout children second 
			add: extraEditor
			label: each windowTitle ]
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

{ #category : 'actions' }
PulsarTabbedMethodEditor >> updateAfterSubmit: result [

	super updateAfterSubmit: result.
	result ifTrue: [ 
		self updateLayout ]
]

{ #category : 'initialization' }
PulsarTabbedMethodEditor >> updateEditor [

	super updateEditor.
	self updateLayout
]

{ #category : 'initialization' }
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

{ #category : 'initialization' }
PulsarTabbedMethodEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	super updatePresenter
]

{ #category : 'accessing' }
PulsarTabbedMethodEditor >> usingLayout [

	^ usingLayout ifNil: [ usingLayout := self layout ]
]
