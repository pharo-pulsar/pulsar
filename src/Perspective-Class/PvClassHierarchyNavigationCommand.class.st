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
	
	popover := self context newPopover.
	
	navigation := (self context 
		instantiate: PvClassHierarchyPresenter on: self model)
		transmitDo: [ :aModel |
			self context notifyActivateEntity: aModel.
			popover dismiss ];
		yourself.
	
	popover
		presenter: navigation;
		relativeTo: self specDecorator presenter;
		bePositionBottom;
		popupModal
]
