Class {
	#name : 'DockNewSlotPresenter',
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
		add: (SpBoxLayout newHorizontal
			beHomogeneous;
			add: cancelButton;
			add: acceptButton;
			yourself); 
		yourself
]

{ #category : 'initialization' }
DockNewSlotPresenter >> initialize [

	super initialize. 
	isOk := false
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
DockNewSlotPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'New variable';
		initialExtent: 400@250
]

{ #category : 'testing' }
DockNewSlotPresenter >> isOk [

	^ isOk
]

{ #category : 'private' }
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
