Class {
	#name : 'DockNewSlotPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'namePresenter',
		'slotPresenter'
	],
	#category : 'Dock-Browser-View-Outline',
	#package : 'Dock-Browser',
	#tag : 'View-Outline'
}

{ #category : 'layout' }
DockNewSlotPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		vAlignStart;
		add: 'Slot Name';
		add: namePresenter;
		add: 'Slot Type';
		add: slotPresenter;
		yourself
]

{ #category : 'initialization' }
DockNewSlotPresenter >> initializeDialogWindow: aDialogWindowPresenter [
	
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
DockNewSlotPresenter >> initializePresenters [
	self addStyle: 'dockDialog'.

	namePresenter := self newTextInput.
	slotPresenter := self newDropDown
]

{ #category : 'initialization' }
DockNewSlotPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'New variable';
		initialExtent: 400@250
]

{ #category : 'initialization' }
DockNewSlotPresenter >> saveThen: aBlock [

	self model 
		name: namePresenter text;
		slotType: slotPresenter selectedItem.
		
	aBlock value
]

{ #category : 'initialization' }
DockNewSlotPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	namePresenter text: self model name.
	slotPresenter 
		items: self model availableSlotTypes;
		selectItem: self model slotType
]
