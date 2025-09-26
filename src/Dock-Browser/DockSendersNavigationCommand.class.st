Class {
	#name : 'DockSendersNavigationCommand',
	#superclass : 'PvMethodEditorCommand',
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'initialization' }
DockSendersNavigationCommand >> defineAction [

	self name: 'Show senders'.
	self description: 'Show senders'.
	self iconCompositeName: 'senders'
]

{ #category : 'initialization' }
DockSendersNavigationCommand >> execute [ 

	self context doBrowseSendersCommand: self
]
