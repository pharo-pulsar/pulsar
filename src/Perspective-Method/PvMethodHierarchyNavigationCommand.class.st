Class {
	#name : #PvMethodHierarchyNavigationCommand,
	#superclass : #PvMethodEditorCommand,
	#category : #'Perspective-Method-Command'
}

{ #category : #initialization }
PvMethodHierarchyNavigationCommand >> defineAction [

	self name: 'Show hierarchy'.
	self description: 'Show method hierarchy'.
	self iconCompositeName: #smallHierarchyBrowser
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
