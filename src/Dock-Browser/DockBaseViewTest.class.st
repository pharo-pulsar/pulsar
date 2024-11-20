Class {
	#name : 'DockBaseViewTest',
	#superclass : 'TestCase',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser',
	#tag : 'Tests'
}

{ #category : 'testing' }
DockBaseViewTest class >> isAbstract [

	^ self = DockBaseViewTest
]

{ #category : 'accessing' }
DockBaseViewTest >> application [

	^ DockApplication new useGtkLight
]

{ #category : 'accessing' }
DockBaseViewTest >> classToTest [

	^ self subclassResponsibility
]
