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
		add: (SpBoxLayout newHorizontal
				add: 'How to checkout:' expand: false;
				add: checkoutStrategyPresenter;
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
			onSuccess: [ self withWindowDo: #close ];
			executeWithContext: self ]
]

{ #category : 'initialization' }
PulsarRepositoryCheckoutWindow >> initializePresenters [

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

{ #category : 'initialization' }
PulsarRepositoryCheckoutWindow >> updatePresenter [
	
	self model ifNil: [ ^ self ].
	
	checkoutStrategyPresenter 
		items: self model checkoutStrategies;
		selectFirst.
	diffPresenter model: self model
]
