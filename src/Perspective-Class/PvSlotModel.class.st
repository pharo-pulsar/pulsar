Class {
	#name : 'PvSlotModel',
	#superclass : 'PvBaseModel',
	#category : 'Perspective-Class-Model',
	#package : 'Perspective-Class',
	#tag : 'Model'
}

{ #category : 'accessing - actions' }
PvSlotModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsFor: #refactors) 
		copyWithContext: (PulsarRefactorSlotContext on: aContextPresenter)
]

{ #category : 'private - definitions' }
PvSlotModel >> defineRefactorActionsOn: aBuilder [
	<dockActions>
	
	"this actions cannot be used directly in this context (the model 
	 context), because execute them require interact with the UI"
	aBuilder addGroup: #refactors with: [ :group | group 
		name: 'Refactors';
		beDisplayedAsGroup.
		
		group
			addActionWith: [ :action | action
				name: ('Generate accesors for {1}' format: { self name });
				description: 'Generate variable accessors';
				action: [ :aContext | aContext doGenerateVariableAccessors: self ] ];
			addActionWith: [ :action | action
				name: ('Rename {1}' format: { self name });
				description: 'Rename method';
				action: [ :aContext | aContext doRenameVariable: self ] ].
			
		self isInstanceVariable ifTrue: [
			group addGroupWith: [ :pullGroup | pullGroup
				beDisplayedAsGroup;
				addActionWith: [ :action | action
					name: ('Pull up {1}' format: { self name });
					description: 'Pull up variable';
					action: [ :aContext | aContext doPullUpVariable: self ] ];
				addActionWith: [ :action | action
					name: ('Push down {1}' format: { self name });
					description: 'Push down variable';
					action: [ :aContext | aContext doPushDownVariable: self ] ] ] 
		] 
	]
]

{ #category : 'accessing' }
PvSlotModel >> iconName [

	^ 'variable'
]

{ #category : 'testing' }
PvSlotModel >> isFromTrait [

	^ self entity definingClass isTrait
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

{ #category : 'actions' }
PvSlotModel >> removeSlot [

	^ self variableClass removeSlot: self entity
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
