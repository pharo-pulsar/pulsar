Class {
	#name : 'DockJobHandler',
	#superclass : 'Object',
	#instVars : [
		'browser',
		'count',
		'spinnerPresenter',
		'mutex'
	],
	#category : 'Dock-Browser-View-Base',
	#package : 'Dock-Browser',
	#tag : 'View-Base'
}

{ #category : 'instance creation' }
DockJobHandler class >> on: aBrowser [

	^ self basicNew
		browser: aBrowser;
		initialize;
		yourself
]

{ #category : 'accessing' }
DockJobHandler >> browser [

	^ browser
]

{ #category : 'initialization' }
DockJobHandler >> browser: aBrowser [

	browser := aBrowser
]

{ #category : 'accessing' }
DockJobHandler >> end [

	mutex critical: [
		logger trace: count.
		
		count = 0 ifTrue: [ ^ self ].
		count := count - 1.
		count = 0 ifTrue: [
			spinnerPresenter ifNotNil: [
				self browser statusbar remove: spinnerPresenter.
				spinnerPresenter := nil ] ] ]
]

{ #category : 'initialization' }
DockJobHandler >> initialize [

	super initialize.
	mutex := Mutex new.
	count := 0
]

{ #category : 'accessing' }
DockJobHandler >> start [
	
	mutex critical: [

		logger trace: count.

		count := count + 1.
		count = 1 ifTrue: [ 
			spinnerPresenter := self browser newSpinner.
			self browser statusbar addPrefix: spinnerPresenter ] ]
]
