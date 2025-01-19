Class {
	#name : 'DockRunTestCommand',
	#superclass : 'DockEditorCommand',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
DockRunTestCommand >> defineAction [

	self name: 'Run test'.
	self description: 'Run this test'.
	self iconCompositeName: 'run-test'
]

{ #category : 'initialization' }
DockRunTestCommand >> execute [

	context doRunTest
]
