"
I am a single column in the Pulsar meta inspector miller list. I display inspection views for an object through a tab layout. Each tab corresponds to an inspection context discovered via pragmas on the object's class hierarchy. I support activation for miller list diving and tab memory across dive operations.
"
Class {
	#name : 'PulsarInspectorPagePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'activationBlock',
		'closeBlock',
		'activateOnSingleClick',
		'selectedTabLabel',
		'tabLabelsByPresenter'
	],
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'private' }
PulsarInspectorPagePresenter >> activate: aSelection [

	activationBlock ifNil: [ ^ self ].
	activationBlock cull: aSelection
]

{ #category : 'accessing' }
PulsarInspectorPagePresenter >> activateOnSingleClick [

	activateOnSingleClick := true
]

{ #category : 'private' }
PulsarInspectorPagePresenter >> addActivationTo: aPresenter [

	aPresenter hasOutputActivationPort ifFalse: [ ^ self ].
	activateOnSingleClick ifTrue: [ aPresenter activateOnSingleClick ].
	aPresenter outputActivationPort transmitDo: [ :selection | self activate: selection ]
]

{ #category : 'private' }
PulsarInspectorPagePresenter >> allContexts [

	^ self model objectInspectionContexts
]

{ #category : 'initialization' }
PulsarInspectorPagePresenter >> defaultLayout [

	^ SpTabLayout new
]

{ #category : 'initialization' }
PulsarInspectorPagePresenter >> initialize [

	activateOnSingleClick := false.
	super initialize
]

{ #category : 'accessing - model' }
PulsarInspectorPagePresenter >> model [

	^ model
]

{ #category : 'accessing - model' }
PulsarInspectorPagePresenter >> model: anInspectorModel [

	(model isNotNil and: [ model inspectedObject == anInspectorModel inspectedObject ]) ifTrue: [ ^ self ].
	model := anInspectorModel.
	self refresh
]

{ #category : 'private - factory' }
PulsarInspectorPagePresenter >> newInspectionForContext: aContext [

	^ self instantiate: StObjectContextPresenter on: (StObjectContextModel new
			   inspection: self model;
			   inspectedObject: self model inspectedObject;
			   context: aContext;
			   yourself)
]

{ #category : 'private - updating' }
PulsarInspectorPagePresenter >> refresh [

	self updateTabs
]

{ #category : 'accessing' }
PulsarInspectorPagePresenter >> selectedPageName [

	^ selectedTabLabel
]

{ #category : 'private' }
PulsarInspectorPagePresenter >> setModel: anInspectorModel [

	self model: anInspectorModel
]

{ #category : 'accessing - model' }
PulsarInspectorPagePresenter >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]

{ #category : 'accessing' }
PulsarInspectorPagePresenter >> trySelectAnyPageWithName: aCollection [

	| labelsToTry |
	labelsToTry := (aCollection asOrderedCollection reject: [ :each | each isNil ]) removeDuplicates.
	labelsToTry ifEmpty: [ ^ self ].

	labelsToTry do: [ :eachName |
			tabLabelsByPresenter keysAndValuesDo: [ :aPresenter :aLabel |
					aLabel = eachName ifTrue: [
							self layout select: aPresenter.
							^ self ] ] ]
]

{ #category : 'initialization' }
PulsarInspectorPagePresenter >> updatePresenter [

	self updateTabs
]

{ #category : 'private - updating' }
PulsarInspectorPagePresenter >> updateTabs [
	| tabLayout |
	
	tabLayout := SpTabLayout new.
	tabLabelsByPresenter := Dictionary new.

	self allContexts do: [ :eachContext |
		| child title |
			title := eachContext title.
			child := self newInspectionForContext: eachContext.
			tabLayout add: child label: title.
			tabLabelsByPresenter at: child put: title.
			self addActivationTo: child ].

	tabLayout whenTabSelectedDo: [ :announcement |
		selectedTabLabel := tabLabelsByPresenter at: announcement presenter ifAbsent: [ nil ] ].

	self layout: tabLayout
]

{ #category : 'api - events' }
PulsarInspectorPagePresenter >> whenActivatedDo: aBlock [

	activationBlock := aBlock
]

{ #category : 'api - events' }
PulsarInspectorPagePresenter >> whenClosedDo: aBlock [

	closeBlock := aBlock
]
