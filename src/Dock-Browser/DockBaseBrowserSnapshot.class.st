Class {
	#name : 'DockBaseBrowserSnapshot',
	#superclass : 'DockBaseSnapshot',
	#instVars : [
		'snapshots',
		'startWidth',
		'endWidth',
		'topHeight',
		'bottomHeight',
		'model'
	],
	#category : 'Dock-Browser-Snapshot',
	#package : 'Dock-Browser',
	#tag : 'Snapshot'
}

{ #category : 'accessing' }
DockBaseBrowserSnapshot >> browserClass [

	^ self subclassResponsibility 
]

{ #category : 'private' }
DockBaseBrowserSnapshot >> filterPresentersToKeep: aCollection [

	^ aCollection
]

{ #category : 'restoring' }
DockBaseBrowserSnapshot >> instantiateOn: anApplication [ 
	
	^ self browserClass 
		newApplication: anApplication 
		model: model
		snapshot: self
]

{ #category : 'restoring' }
DockBaseBrowserSnapshot >> restorePanelSnapshot: aSnapshot to: aDockBrowser [
	| panelPresenter |
	
	panelPresenter :=  aSnapshot instantiateOn: aDockBrowser.
	aDockBrowser 
		addPresenter: panelPresenter 
		at: aSnapshot dockPosition.
	aSnapshot restoreTo: panelPresenter
]

{ #category : 'restoring' }
DockBaseBrowserSnapshot >> restoreTo: aDockBrowser [

	startWidth ifNotNil: [ aDockBrowser startWidth: (startWidth max: 280) ].
	endWidth ifNotNil: [ aDockBrowser endWidth: (endWidth max: 280) ].
	"Not used at the moment"
	"topHeight ifNotNil: [ aDockBrowser topHeight: topHeight ]."
	bottomHeight ifNotNil: [ aDockBrowser bottomHeight: (bottomHeight max: 180) ].

	self snapshots do: [ :each | 
		self restorePanelSnapshot: each to: aDockBrowser ].

	self selectLastActiveEditorOn: aDockBrowser.		

	aDockBrowser postRestoreSnapshot: self
]

{ #category : 'restoring' }
DockBaseBrowserSnapshot >> selectLastActiveEditorOn: aDockBrowser [
	| editors  lastPresented |
	
	editors := aDockBrowser editors.
	editors ifEmpty: [ ^ self ].

	lastPresented := (editors 
		sorted: [ :each | each presenter lastTimePresented ifNil: [ DateAndTime epoch ] ] 
		descending)
		first.
		
	aDockBrowser whenOpenedDo: [
		aDockBrowser application schedule: [
			100 milliSeconds wait.
			aDockBrowser application defer: [
				lastPresented raiseAndTakeKeyboardFocus ] ] ]
]

{ #category : 'initialization' }
DockBaseBrowserSnapshot >> snapshot: aDockBrowser [

	model := aDockBrowser model copy.

	startWidth := aDockBrowser startWidth.
	endWidth := aDockBrowser endWidth.
	topHeight := aDockBrowser topHeight.
	bottomHeight := aDockBrowser bottomHeight.

	snapshots := (self filterPresentersToKeep: aDockBrowser presenters)
		collect: [ :each | each presenter snapshot ]
		as: Array
]

{ #category : 'accessing' }
DockBaseBrowserSnapshot >> snapshotWithClass: aClass [
	"So far, this should be used just for testing (but we never know :P)"

	^ self snapshots 
		detect: [ :each | each class = aClass ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
DockBaseBrowserSnapshot >> snapshots [

	^ snapshots
]

{ #category : 'accessing' }
DockBaseBrowserSnapshot >> snapshots: anObject [

	snapshots := anObject
]
