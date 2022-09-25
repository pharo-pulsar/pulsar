Class {
	#name : #PvClassHierarchyNavigationCommand,
	#superclass : #PvClassCommand,
	#category : #'Perspective-Class-View'
}

{ #category : #'accessing - defaults' }
PvClassHierarchyNavigationCommand class >> defaultDescription [

	^ 'Show class hierarchy'
]

{ #category : #'accessing - defaults' }
PvClassHierarchyNavigationCommand class >> defaultIconComposite [

	^ PvCompositeIcon new 
		name: #smallHierarchyBrowser;
		yourself
]

{ #category : #'accessing - defaults' }
PvClassHierarchyNavigationCommand class >> defaultName [

	^ 'Show hierarchy'
]

{ #category : #initialization }
PvClassHierarchyNavigationCommand class >> defaultShortcut [

	^ $h ctrl
]

{ #category : #'default - groups' }
PvClassHierarchyNavigationCommand class >> groups [

	^ #()
]

{ #category : #testing }
PvClassHierarchyNavigationCommand class >> isVisibleInMenu [

	^ false
]

{ #category : #executing }
PvClassHierarchyNavigationCommand >> execute [
	| popover navigation |
	
	navigation := self context 
		instantiate: PvClassHierarchyPresenter 
		on: self model.
	navigation outputActivationPort 
		transmitDo: [ :aModel | 
			self context withPerspectiveDo: [ :aPerspective | 
				aPerspective activateClass: aModel entity ].
			popover dismiss ].
	
	(popover := self context newPopover)
		presenter: navigation;
		relativeTo: self specDecorator presenter;
		bePositionBottom;
		popup
]
