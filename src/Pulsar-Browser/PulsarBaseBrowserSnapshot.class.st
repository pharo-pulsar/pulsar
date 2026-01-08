Class {
	#name : 'PulsarBaseBrowserSnapshot',
	#superclass : 'PulsarBaseSnapshot',
	#instVars : [
		'snapshots',
		'startWidth',
		'endWidth',
		'topHeight',
		'bottomHeight',
		'model'
	],
	#category : 'Pulsar-Browser-Snapshot',
	#package : 'Pulsar-Browser',
	#tag : 'Snapshot'
}

{ #category : 'accessing' }
PulsarBaseBrowserSnapshot >> browserClass [

	^ self subclassResponsibility 
]

{ #category : 'private' }
PulsarBaseBrowserSnapshot >> filterPresentersToKeep: aCollection [

	^ aCollection
]

{ #category : 'restoring' }
PulsarBaseBrowserSnapshot >> instantiateOn: anApplication [ 
	
	^ self browserClass 
		newApplication: anApplication 
		model: model
		snapshot: self
]

{ #category : 'restoring' }
PulsarBaseBrowserSnapshot >> restorePanelSnapshot: aSnapshot to: aPulsarBrowser [
	| panelPresenter |
	
	panelPresenter :=  aSnapshot instantiateOn: aPulsarBrowser.
	aPulsarBrowser 
		addPresenter: panelPresenter 
		at: aSnapshot panelPosition.
	aSnapshot restoreTo: panelPresenter
]

{ #category : 'restoring' }
PulsarBaseBrowserSnapshot >> restoreTo: aPulsarBrowser [

	startWidth ifNotNil: [ aPulsarBrowser startWidth: (startWidth max: 280) ].
	endWidth ifNotNil: [ aPulsarBrowser endWidth: (endWidth max: 280) ].
	"Not used at the moment"
	"topHeight ifNotNil: [ aPulsarBrowser topHeight: topHeight ]."
	bottomHeight ifNotNil: [ aPulsarBrowser bottomHeight: (bottomHeight max: 180) ].

	self snapshots do: [ :each | 
		self restorePanelSnapshot: each to: aPulsarBrowser ].

	self selectLastActiveEditorOn: aPulsarBrowser.		

	aPulsarBrowser postRestoreSnapshot: self
]

{ #category : 'restoring' }
PulsarBaseBrowserSnapshot >> selectLastActiveEditorOn: aPulsarBrowser [
	| editors  lastPresented |
	
	editors := aPulsarBrowser editors.
	editors ifEmpty: [ ^ self ].

	lastPresented := (editors 
		sorted: [ :each | each presenter lastTimePresented ifNil: [ DateAndTime epoch ] ] 
		descending)
		first.
		
	aPulsarBrowser whenOpenedDo: [
		aPulsarBrowser application schedule: [
			100 milliSeconds wait.
			aPulsarBrowser application defer: [
				lastPresented raiseAndTakeKeyboardFocus ] ] ]
]

{ #category : 'initialization' }
PulsarBaseBrowserSnapshot >> snapshot: aPulsarBrowser [

	model := aPulsarBrowser model copy.

	startWidth := aPulsarBrowser startWidth.
	endWidth := aPulsarBrowser endWidth.
	topHeight := aPulsarBrowser topHeight.
	bottomHeight := aPulsarBrowser bottomHeight.

	snapshots := (self filterPresentersToKeep: aPulsarBrowser presenters)
		collect: [ :each | each presenter snapshot ]
		as: Array
]

{ #category : 'accessing' }
PulsarBaseBrowserSnapshot >> snapshotWithClass: aClass [
	"So far, this should be used just for testing (but we never know :P)"

	^ self snapshots 
		detect: [ :each | each class = aClass ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
PulsarBaseBrowserSnapshot >> snapshots [

	^ snapshots
]

{ #category : 'accessing' }
PulsarBaseBrowserSnapshot >> snapshots: anObject [

	snapshots := anObject
]
