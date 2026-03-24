"
A base for all components that will be opened as a window.  

This is not a browser as children of `PulsarBaseBrowser`, hence children of `PulsarBaseWindow` will not open a panel workspace, but they will behave as a full citizen of Pulsar in any other case: 

- is integrated to the application, and its notification center.
- it includes a scheduler, and a job scheduler

"
Class {
	#name : 'PulsarBaseWindow',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTSnapshot + PulsarTTaskScheduler + PulsarTJobHandler',
	#classTraits : 'SpTModel classTrait + PulsarTSnapshot classTrait + PulsarTTaskScheduler classTrait + PulsarTJobHandler classTrait',
	#classInstVars : [
		'lastWindowSize'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing - defaults' }
PulsarBaseWindow class >> defaultWindowSize [

	^ 1100 @ 950
]

{ #category : 'accessing' }
PulsarBaseWindow class >> lastWindowSize [

	^ lastWindowSize ifNil: [ self defaultWindowSize ]
]

{ #category : 'accessing' }
PulsarBaseWindow class >> lastWindowSize: aSize [

	lastWindowSize := aSize
]

{ #category : 'adding' }
PulsarBaseWindow >> addStatusbarPresenter: aPresenter [

	self window statusbar addPrefix: aPresenter
]

{ #category : 'private' }
PulsarBaseWindow >> cleanUpSchedulers [
	
	announcer ifNotNil: #purgeTaskWorker.
	self purgeTaskScheduler
]

{ #category : 'private - initialization' }
PulsarBaseWindow >> initializePrivateAnnouncer [

  announcer := PulsarTaskAnnouncer new
]

{ #category : 'initialization' }
PulsarBaseWindow >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		initialExtent: self class lastWindowSize;
		whenResizingDo: [ :ann | self class lastWindowSize: ann newSize ];
		whenWillCloseDo: [ :ann | 
			self windowWillClose 
				ifFalse: [ ann denyClose ] ];
		whenClosedDo: [ self windowClosed ].
		
	
]

{ #category : 'adding' }
PulsarBaseWindow >> removeStatusbarPresenter: aPresenter [

	self window removeStatusbarPresenter: aPresenter
]

{ #category : 'private' }
PulsarBaseWindow >> scheduleJob: aBlock [
	"schedule a task that will show the working spinner while it executes"

	self scheduleTask: [
		self jobStart.
		[ aBlock cull: self window statusbar ]
		ensure: [
			self window statusbar clearMessage.
			self jobEnd ] ]
]

{ #category : 'private' }
PulsarBaseWindow >> windowClosed [

	self cleanUpSchedulers
]

{ #category : 'private' }
PulsarBaseWindow >> windowWillClose [

	^ true
]
