Class {
	#name : 'PulsarRepositoryCheckoutWindow',
	#superclass : 'PulsarBaseWindow',
	#instVars : [
		'checkoutStrategyPresenter',
		'diffPresenter',
		'lastWindowSize'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarRepositoryCheckoutWindow >> defaultLayout [

	^ SpBoxLayout newVertical
		add: (self newPresenter 
				addStyle: 'checkoutStrategy';
				layout: (SpBoxLayout newHorizontal
					add: 'How to checkout:' expand: false;
					add: checkoutStrategyPresenter;
					yourself);
				yourself)
			expand: false;
		add: diffPresenter;
		yourself
]

{ #category : 'actions' }
PulsarRepositoryCheckoutWindow >> doCheckout [
	| strategy |
	
	strategy := checkoutStrategyPresenter selectedItem.
	self scheduleJob: [
		(self model newCheckoutActionWithStrategy: strategy) 
			onSuccess: [ 
				"announce here because the iceberg announcer is kind of internal, and I do not want to hang on
				 `Icebereg announcer`, which seems to me prone to leak."
				self notifyRepositoryModified: self model.
				self withWindowDo: #close ];
			executeWithContext: self ]
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutWindow >> initializePresenters [

	self addStyle: 'pulsarRepositoryRepairWindow'.
	self addStyle: 'pulsarRepositoryCheckout'.

	checkoutStrategyPresenter := self newDropList
		display: [ :aStrategyClass | aStrategyClass description ];
		yourself.
	diffPresenter := self instantiate: PulsarRepositoryDiffPresenter
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutWindow >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter 
		title: 'Checkout';
		addControl: (self newButton
			label: 'Checkout';
			icon: (self iconNamed: 'checkout');
			action: [ self doCheckout ];
			yourself)
]

{ #category : 'private' }
PulsarRepositoryCheckoutWindow >> notifyRepositoryModified: aModel [
	| announcementModel |
	
	announcementModel := (aModel respondsTo: #repositoryModel)
		ifTrue: [ aModel repositoryModel ]
		ifFalse: [ aModel ].

	logger trace: announcementModel.

	self application resendAnnouncement: (PulsarRepositoryModified newValue: announcementModel)
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutWindow >> updatePresenter [
	
	self model ifNil: [ ^ self ].
	
	checkoutStrategyPresenter 
		items: self model checkoutStrategies;
		selectFirst.

	diffPresenter model: self model
]
