Class {
	#name : 'DockHierarchyNavigationCommand',
	#superclass : 'PvMethodEditorCommand',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
DockHierarchyNavigationCommand >> defineAction [

	self name: 'Show hierarchy'.
	self description: 'Show hierarchy'.
	self iconCompositeName: #smallHierarchyBrowser
]

{ #category : 'executing' }
DockHierarchyNavigationCommand >> execute [
	| popover navigation |
	
	popover := self context newPopover.
	navigation := self context 
		instantiate: DockHierarchyPresenter 
		on: (DockHierarchyModel on: self model). 
	
	navigation notificationCenter: self context notificationCenter.
	
	popover
		presenter: navigation;
		relativeTo: self specDecorator presenter;
		popupModal
]
