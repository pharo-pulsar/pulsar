Class {
	#name : #PvMethodHierarchyNavigationCommand,
	#superclass : #PvMethodEditorCommand,
	#category : #'Perspective-Method-Command'
}

{ #category : #'accessing - defaults' }
PvMethodHierarchyNavigationCommand class >> defaultDescription [

	^ 'Show method hierarchy'
]

{ #category : #'accessing - defaults' }
PvMethodHierarchyNavigationCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: #smallHierarchyBrowser;
		yourself
]

{ #category : #'accessing - defaults' }
PvMethodHierarchyNavigationCommand class >> defaultName [

	^ 'Show hierarchy'
]

{ #category : #'accessing - defaults' }
PvMethodHierarchyNavigationCommand class >> defaultShortcut [

	^ $h control
]

{ #category : #'accessing - defaults' }
PvMethodHierarchyNavigationCommand class >> groups [

	^ #()
]

{ #category : #'accessing - defaults' }
PvMethodHierarchyNavigationCommand class >> isVisibleInMenu [

	^ false
]

{ #category : #executing }
PvMethodHierarchyNavigationCommand >> execute [
	| popover navigation |
	
	navigation := self context 
		instantiate: PvMethodHierarchyPresenter
		on: self model.
	navigation outputActivationPort 
		transmitDo: [ :aModel | 
			self context withPerspectiveDo: [ :aPerspective | 
				aPerspective activateMethod: aModel entity ].
			popover dismiss ].
	
	(popover := self context newPopover)
		presenter: navigation;
		relativeTo: self specDecorator presenter;
		bePositionBottom;
		popup
]
