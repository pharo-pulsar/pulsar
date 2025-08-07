Class {
	#name : 'DockBrowserPanelAreaVisible',
	#superclass : 'SpPanelAreaVisitor',
	#instVars : [
		'browser'
	],
	#category : 'Dock-Browser-View-Browser',
	#package : 'Dock-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing' }
DockBrowserPanelAreaVisible class >> minBottomHeight [ 

	^ 150
]

{ #category : 'accessing' }
DockBrowserPanelAreaVisible class >> minEndWidth [ 

	^ 200
]

{ #category : 'accessing' }
DockBrowserPanelAreaVisible class >> minStartHeight [ 

	^ 150
]

{ #category : 'accessing' }
DockBrowserPanelAreaVisible class >> minStartWidth [ 

	^ 200
]

{ #category : 'accessing' }
DockBrowserPanelAreaVisible class >> minTopHeight [ 

	^ 150
]

{ #category : 'instance creation' }
DockBrowserPanelAreaVisible class >> on: aDockBrowser [

	^ self new 
		browser: aDockBrowser;
		yourself
]

{ #category : 'accessing' }
DockBrowserPanelAreaVisible >> browser: aBrowser [

	browser := aBrowser
]

{ #category : 'visiting' }
DockBrowserPanelAreaVisible >> visitBottom: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser bottomVisible: newStatus.
	newStatus ifTrue: [
		browser bottomHeight < self class minBottomHeight 
			ifTrue: [ browser bottomHeight: self class minBottomHeight ] ]
]

{ #category : 'visiting' }
DockBrowserPanelAreaVisible >> visitEnd: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser endVisible: newStatus.
	newStatus ifTrue: [
		browser endWidth < self class minEndWidth
			ifTrue: [ browser endWidth: self class minEndWidth ] ]
]

{ #category : 'visiting' }
DockBrowserPanelAreaVisible >> visitStart: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser startVisible: newStatus.
	newStatus ifTrue: [
		browser startWidth < self class minStartWidth 
			ifTrue: [ browser startWidth: self class minStartWidth ] ]
]

{ #category : 'visiting' }
DockBrowserPanelAreaVisible >> visitTop: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser topVisible: newStatus.
	newStatus ifTrue: [
		browser topHeight < self class minTopHeight 
			ifTrue: [ browser topHeight: self class minTopHeight ] ]
]
