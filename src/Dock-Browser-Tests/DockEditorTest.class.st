Class {
	#name : 'DockEditorTest',
	#superclass : 'DockBaseViewTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'testing' }
DockEditorTest class >> isAbstract [

	^ super isAbstract or: [ self = DockEditorTest ]
]
