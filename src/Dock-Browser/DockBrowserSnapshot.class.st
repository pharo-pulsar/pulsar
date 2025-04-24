Class {
	#name : 'DockBrowserSnapshot',
	#superclass : 'DockBaseSnapshot',
	#instVars : [
		'snapshots',
		'startWidth',
		'endWidth',
		'topHeight',
		'bottomHeight'
	],
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'restoring' }
DockBrowserSnapshot >> instantiateOn: anApplication [ 
	
	^ anApplication new: DockBrowser
]

{ #category : 'restoring' }
DockBrowserSnapshot >> restorePanelSnapshot: aSnapshot to: aDockBrowser [
	| panelPresenter |
	
	panelPresenter :=  aSnapshot instantiateOn: aDockBrowser.
	aDockBrowser 
		addPresenter: panelPresenter 
		at: aSnapshot dockPosition.
	aSnapshot restoreTo: panelPresenter
]

{ #category : 'restoring' }
DockBrowserSnapshot >> restoreTo: aDockBrowser [

	startWidth ifNotNil: [ aDockBrowser startWidth: (startWidth max: 280) ].
	endWidth ifNotNil: [ aDockBrowser endWidth: (endWidth max: 280) ].
	"Not used at the moment"
	"topHeight ifNotNil: [ aDockBrowser topHeight: topHeight ]."
	bottomHeight ifNotNil: [ aDockBrowser bottomHeight: (bottomHeight max: 180) ].

	self snapshots do: [ :each | 
		self restorePanelSnapshot: each to: aDockBrowser ].
		
	aDockBrowser postRestoreSnapshot: self
]

{ #category : 'initialization' }
DockBrowserSnapshot >> snapshot: aDockBrowser [

	startWidth := aDockBrowser startWidth.
	endWidth := aDockBrowser endWidth.
	topHeight := aDockBrowser topHeight.
	bottomHeight := aDockBrowser bottomHeight.

	snapshots := aDockBrowser presenters
		collect: [ :each | each presenter snapshot ]
		as: Array
]

{ #category : 'accessing' }
DockBrowserSnapshot >> snapshotWithClass: aClass [
	"So far, this should be used just for testing (but we never know :P)"

	^ self snapshots 
		detect: [ :each | each class = aClass ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
DockBrowserSnapshot >> snapshots [

	^ snapshots
]

{ #category : 'accessing' }
DockBrowserSnapshot >> snapshots: anObject [

	snapshots := anObject
]
