Class {
	#name : 'PulsarBrowserPanelAreaVisible',
	#superclass : 'SpPanelAreaVisitor',
	#instVars : [
		'browser'
	],
	#category : 'Pulsar-Browser-View-Browser',
	#package : 'Pulsar-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing' }
PulsarBrowserPanelAreaVisible class >> minBottomHeight [ 

	^ 150
]

{ #category : 'accessing' }
PulsarBrowserPanelAreaVisible class >> minEndWidth [ 

	^ 200
]

{ #category : 'accessing' }
PulsarBrowserPanelAreaVisible class >> minStartHeight [ 

	^ 150
]

{ #category : 'accessing' }
PulsarBrowserPanelAreaVisible class >> minStartWidth [ 

	^ 200
]

{ #category : 'accessing' }
PulsarBrowserPanelAreaVisible class >> minTopHeight [ 

	^ 150
]

{ #category : 'instance creation' }
PulsarBrowserPanelAreaVisible class >> on: aPulsarBrowser [

	^ self new 
		browser: aPulsarBrowser;
		yourself
]

{ #category : 'accessing' }
PulsarBrowserPanelAreaVisible >> browser: aBrowser [

	browser := aBrowser
]

{ #category : 'visiting' }
PulsarBrowserPanelAreaVisible >> visitBottom: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser bottomVisible: newStatus.
	newStatus ifTrue: [
		browser bottomHeight < self class minBottomHeight 
			ifTrue: [ browser bottomHeight: self class minBottomHeight ] ]
]

{ #category : 'visiting' }
PulsarBrowserPanelAreaVisible >> visitEnd: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser endVisible: newStatus.
	newStatus ifTrue: [
		browser endWidth < self class minEndWidth
			ifTrue: [ browser endWidth: self class minEndWidth ] ]
]

{ #category : 'visiting' }
PulsarBrowserPanelAreaVisible >> visitStart: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser startVisible: newStatus.
	newStatus ifTrue: [
		browser startWidth < self class minStartWidth 
			ifTrue: [ browser startWidth: self class minStartWidth ] ]
]

{ #category : 'visiting' }
PulsarBrowserPanelAreaVisible >> visitTop: anArea [
	| newStatus |

	newStatus := (browser isAreaVisible: anArea) not.
	browser topVisible: newStatus.
	newStatus ifTrue: [
		browser topHeight < self class minTopHeight 
			ifTrue: [ browser topHeight: self class minTopHeight ] ]
]
