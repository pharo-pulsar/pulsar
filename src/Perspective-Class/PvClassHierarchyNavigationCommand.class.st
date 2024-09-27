Class {
	#name : 'PvClassHierarchyNavigationCommand',
	#superclass : 'PvClassCommand',
	#category : 'Perspective-Class-View',
	#package : 'Perspective-Class',
	#tag : 'View'
}

{ #category : 'initialization' }
PvClassHierarchyNavigationCommand class >> defaultShortcut [

	^ $h mod1
]

{ #category : 'initialization' }
PvClassHierarchyNavigationCommand >> defineAction [

	self name: 'Show hierarchy'.
	self description: 'Show class hierarchy'.
	self iconCompositeName: #smallHierarchyBrowser.
	
]

{ #category : 'executing' }
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
