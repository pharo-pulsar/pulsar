Class {
	#name : 'PvSlotModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'accessing - actions' }
PvSlotModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: 'refactors') 
		copyWithContext: (PulsarRefactorSlotContext on: aContextPresenter)
]

{ #category : 'private - definitions' }
PvSlotModel >> defineRefactorActionsOn: aBuilder [
	<dockActions>
	
	"this actions cannot be used directly in this context (the model 
	 context), because execute them require interact with the UI"
	aBuilder addGroup: #refactors with: [ :group | group 
		name: 'Refactors';
		beDisplayedAsSubMenu.
		
		group addActionWith: [ :action | action
			name: ('Rename {1}' format: { self name });
			description: 'Rename method';
			action: [ :aContext | aContext doRenameVariable: self ] ].
			
		self isInstanceVariable ifTrue: [
			group 
				 
				addActionWith: [ :action | action
					name: ('Pull up {1}' format: { self name });
					description: 'Pull up variable';
					action: [ :aContext | aContext doPullUpVariable: self ] ];
				addActionWith: [ :action | action
					name: ('Push down {1}' format: { self name });
					description: 'Push down variable';
					action: [ :aContext | aContext doPushDownVariable: self ] ] 
		] 
	]
]

{ #category : 'accessing' }
PvSlotModel >> iconName [

	^ 'variable'
]

{ #category : 'testing' }
PvSlotModel >> isIncludedIn: aMethodModel [

	^ aMethodModel entity variableNodes anySatisfy: [ :each | each name = self name ]
]

{ #category : 'testing' }
PvSlotModel >> isInstanceVariable [

	^ self entity definingClass isInstanceSide
]

{ #category : 'accessing' }
PvSlotModel >> name [

	^ self entity name
]

{ #category : 'accessing' }
PvSlotModel >> slotName [

	self entity class = InstanceVariableSlot ifTrue: [ ^ '' ].
	^ self entity className
]

{ #category : 'accessing' }
PvSlotModel >> variableClass [

	^ self entity definingClass
]
