Class {
	#name : 'PulsarNewSlotPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'namePresenter',
		'slotPresenter',
		'cancelButton',
		'acceptButton',
		'isOk'
	],
	#category : 'Pulsar-Browser-View-Outline',
	#package : 'Pulsar-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
PulsarNewSlotPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		vAlignStart;
		add: 'Slot Name';
		add: namePresenter;
		add: 'Slot Type';
		add: slotPresenter;
		add: (SpBoxLayout newHorizontal
			beHomogeneous;
			add: cancelButton;
			add: acceptButton;
			yourself); 
		yourself
]

{ #category : 'initialization' }
PulsarNewSlotPresenter >> initialize [

	super initialize. 
	isOk := false
]

{ #category : 'initialization' }
PulsarNewSlotPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	
	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Create' do: [ :presenter | 
			self saveThen: [
				presenter triggerOkAction.
				presenter beOk.
				presenter close ] ]
]

{ #category : 'initialization' }
PulsarNewSlotPresenter >> initializePresenters [

	self addStyle: 'dockDialog'.

	namePresenter := self newTextInput.
	slotPresenter := self newDropDown.
	
	cancelButton := self newButton
		label: 'Cancel';
		action: [ self withPopoverDo: #dismiss ].
		
	acceptButton := self newButton
		label: 'Add';
		addStyle: 'suggested-action';
		action: [ 
			self saveThen: [ 
				isOk := true.
				self withPopoverDo: #dismiss ] ]
]

{ #category : 'initialization' }
PulsarNewSlotPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'New variable';
		initialExtent: 400@250
]

{ #category : 'testing' }
PulsarNewSlotPresenter >> isOk [

	^ isOk
]

{ #category : 'private' }
PulsarNewSlotPresenter >> saveThen: aBlock [

	self model 
		name: namePresenter text;
		slotType: slotPresenter selectedItem.

	aBlock value
]

{ #category : 'initialization' }
PulsarNewSlotPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter text: self model name.
	slotPresenter 
		items: self model availableSlotTypes;
		selectItem: self model slotType
]
