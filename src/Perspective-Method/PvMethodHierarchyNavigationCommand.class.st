Class {
	#name : 'PvMethodHierarchyNavigationCommand',
	#superclass : 'PvMethodEditorCommand',
	#category : 'Perspective-Method-Command',
	#package : 'Perspective-Method',
	#tag : 'Command'
}

{ #category : 'initialization' }
PvMethodHierarchyNavigationCommand >> defineAction [

	self name: 'Show hierarchy'.
	self description: 'Show method hierarchy'.
	self iconCompositeName: #smallHierarchyBrowser
]

{ #category : 'executing' }
PvMethodHierarchyNavigationCommand >> execute [
	| popover navigation |
	
	popover := self context newPopover.
	
	navigation := (self context 
		instantiate: PvMethodHierarchyPresenter on: self model)
		transmitDo: [ :aModel | 
			self context triggerActivateEntity: aModel.
			popover dismiss ];
		yourself.
	
	popover
		presenter: navigation;
		relativeTo: self specDecorator presenter;
		bePositionBottom;
		popupModal
]
