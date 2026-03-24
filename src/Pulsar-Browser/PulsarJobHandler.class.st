Class {
	#name : 'PulsarJobHandler',
	#superclass : 'Object',
	#instVars : [
		'browser',
		'count',
		'spinnerPresenter',
		'mutex'
	],
	#category : 'Pulsar-Browser-View-Base',
	#package : 'Pulsar-Browser',
	#tag : 'View-Base'
}

{ #category : 'instance creation' }
PulsarJobHandler class >> on: aBrowser [

	^ self basicNew
		browser: aBrowser;
		initialize;
		yourself
]

{ #category : 'accessing' }
PulsarJobHandler >> browser [

	^ browser
]

{ #category : 'initialization' }
PulsarJobHandler >> browser: aBrowser [

	browser := aBrowser
]

{ #category : 'accessing' }
PulsarJobHandler >> end [

	mutex critical: [
		logger trace: count.
		
		count = 0 ifTrue: [ ^ self ].
		count := count - 1.
		count = 0 ifTrue: [
			spinnerPresenter ifNotNil: [
				self browser removeStatusbarPresenter: spinnerPresenter.
				spinnerPresenter := nil ] ] ]
]

{ #category : 'initialization' }
PulsarJobHandler >> initialize [

	super initialize.
	mutex := Mutex new.
	count := 0
]

{ #category : 'accessing' }
PulsarJobHandler >> start [
	
	mutex critical: [

		logger trace: count.

		count := count + 1.
		count = 1 ifTrue: [ 
			spinnerPresenter := self browser newSpinner.
			self browser addStatusbarPresenter: spinnerPresenter ] ]
]
