Class {
	#name : 'PulsarBrowserSnapshot',
	#superclass : 'PulsarBaseBrowserSnapshot',
	#category : 'Pulsar-Browser-View-Browser',
	#package : 'Pulsar-Browser',
	#tag : 'View-Browser'
}

{ #category : 'accessing' }
PulsarBrowserSnapshot >> browserClass [

	^ PulsarBrowser
]

{ #category : 'accessing' }
PulsarBrowserSnapshot >> restorePriority [
	"restore first"
	
^ 1
]
