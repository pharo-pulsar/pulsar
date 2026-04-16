"
A base for all pulsar windows.
It includes a statusbar, is posible to push messages.
It includes a scheduler, is posible to schedule tasks.

"
Class {
	#name : 'PulsarWindowPresenter',
	#superclass : 'SpWindowPresenter',
	#traits : 'PulsarTTaskScheduler + PulsarTJobHandler + PulsarTSnapshot',
	#classTraits : 'PulsarTTaskScheduler classTrait + PulsarTJobHandler classTrait + PulsarTSnapshot classTrait',
	#instVars : [
		'controls'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'accessing' }
PulsarWindowPresenter >> addControl: aPresenter [

	controls ifNil: [ controls := #() ].
	
	aPresenter owner: self.
	controls := controls copyWith: aPresenter.
	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter addWindowControl: aPresenter ]
]

{ #category : 'private' }
PulsarWindowPresenter >> addStatusbarPresenter: aPresenter [
	
	self statusbar addPrefix: aPresenter
]

{ #category : 'accessing' }
PulsarWindowPresenter >> controlsEnabled: aBoolean [

	controls ifNil: [ ^ self ].
	controls do: [ :each | each enabled: aBoolean ]
]

{ #category : 'initialization' }
PulsarWindowPresenter >> initialize [

	super initialize.
	self statusbar: (self instantiate: SpPanelStatusbarPresenter)
]

{ #category : 'private' }
PulsarWindowPresenter >> removeStatusbarPresenter: aPresenter [
	
	self statusbar remove: aPresenter
]

{ #category : 'private' }
PulsarWindowPresenter >> scheduleJob: aBlock [
	"schedule a task that will show the working spinner while it executes"

	self scheduleTask: [
		self jobStart.
		self controlsEnabled: false.
		[ aBlock cull: self statusbar ]
		ensure: [ 
			self statusbar clearMessage.
			self controlsEnabled: true.
			self jobEnd ] ]
]

{ #category : 'accessing - snapshot' }
PulsarWindowPresenter >> snapshot [

	^ PulsarWindowSnapshot on: self
]
