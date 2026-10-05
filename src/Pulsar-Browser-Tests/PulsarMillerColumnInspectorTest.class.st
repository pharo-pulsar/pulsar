Class {
	#name : 'PulsarMillerColumnInspectorTest',
	#superclass : 'PulsarBaseViewTest',
	#instVars : [
		'inspector'
	],
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarMillerColumnInspectorTest >> addMockColumnClass [

	| mockClass |
	mockClass := (Object << #PulsarMockColumnForTestToRemove)
		             slots: #( 'received' 'properties' );
		             package: 'Pulsar-Browser-Tests';
		             install.
	mockClass
		compile: 'received

		^ received ifNil: [ false ]';
		compile: 'insertPopover: aPresenter

		received := true.
		^ aPresenter';
		compile: 'propertyAt: aSymbol

		^ properties ifNil: [ ^ nil ] ifNotNil: [ :dict | dict at: aSymbol ifAbsent: [ nil ] ]';
		compile:
			'propertyAt: aSymbol put: aValue

		(properties ifNil: [ properties := IdentityDictionary new ]) at: aSymbol put: aValue';
		compile: 'outputActivationPort

		^ self';
		compile: 'transmitDo: aBlock

		^ self'.
	^ mockClass
]

{ #category : 'accessing' }
PulsarMillerColumnInspectorTest >> classToTest [

	^ PulsarMillerColumnInspector
]

{ #category : 'accessing' }
PulsarMillerColumnInspectorTest >> inspector [

	^ inspector ifNil: [ inspector := self newInspectorOn: 'hello' ]
]

{ #category : 'accessing' }
PulsarMillerColumnInspectorTest >> millerList [

	^ self inspector instVarNamed: 'millerList'
]

{ #category : 'accessing' }
PulsarMillerColumnInspectorTest >> newInspectorOn: anObject [

	^ self classToTest newApplication: self application model: (PulsarInspectorModel on: anObject)
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testAddColumnAddsSecondColumn [

	self inspector addColumn: (PulsarInspectorModel on: 42).
	self waitForUI.

	self assert: self millerList children size equals: 2
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testAddPopoverControlsAddsControlBox [

	| header |
	header := self inspector instVarNamed: 'headerPresenter'.
	self deny: (header presenters anySatisfy: [ :each | each isKindOf: PulsarPopoverControlBoxPresenter ]).

	self inspector addPopoverControls.

	self assert: (header presenters anySatisfy: [ :each | each isKindOf: PulsarPopoverControlBoxPresenter ])
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testFirstColumnIsCreatedFromModel [

	| column |
	column := self millerList children first.
	self assert: self millerList children size equals: 1.
	self assert: (column isKindOf: PulsarSingleInspector).
	self assert: column model equals: self inspector model
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testHeaderPresenterIsCreated [

	| header |
	header := self inspector instVarNamed: 'headerPresenter'.
	self assert: (header isKindOf: PulsarEditorToolbarPresenter)
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testInitializePopoverAddsControlBox [

	| popover header |
	popover := SpPopoverPresenter newApplication: self application owner: nil.
	header := self inspector instVarNamed: 'headerPresenter'.

	self inspector initializePopover: popover.

	self assert: (header presenters anySatisfy: [ :each | each isKindOf: PulsarPopoverControlBoxPresenter ])
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testInsertPopoverDelegatesToLastColumn [

	| mockClass mockColumn |
	mockClass := self addMockColumnClass.
	mockColumn := mockClass new.
	self inspector addPresenterToList: mockColumn.
	self waitForUI.

	self inspector insertPopover: #aPopover.

	self assert: mockColumn received.
	mockClass removeFromSystemUnlogged
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testNotifyActivateEntityAnnouncesActivation [

	| announcer lastAnnouncement |
	announcer := Announcer new.
	announcer when: PulsarAnnouncement do: [ :a | lastAnnouncement := a ] for: announcer.
	self inspector basicNotificationCenter: announcer.

	self inspector notifyActivateEntity: self inspector model.

	self assert: (lastAnnouncement isKindOf: PulsarModelActivated)
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testNotifyActivateEntityNilDoesNotAnnounce [

	| announcer announcedCount |
	announcer := Announcer new.
	announcedCount := 0.
	announcer when: PulsarAnnouncement do: [ :a | announcedCount := announcedCount + 1 ] for: announcer.
	self inspector basicNotificationCenter: announcer.

	self inspector notifyActivateEntity: nil.

	self assert: announcedCount equals: 0
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testShiftRangeAtBounds [

	| insp |
	insp := self newInspectorOn: 'x'.
	3 timesRepeat: [ insp addColumn: (PulsarInspectorModel on: Object new) ].
	self waitForUI.

	insp moveTo: 1.
	self waitForUI.
	self assert: insp visibleRange first equals: 1.

	insp shiftRange: -1.
	self waitForUI.
	self assert: insp visibleRange first equals: 1
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testThemeEventsAreHandled [

	self inspector announcer announce: PulsarThemeChanged new.
	self inspector announcer announce: PulsarSyntaxHighlightThemeChanged new
]

{ #category : 'tests' }
PulsarMillerColumnInspectorTest >> testVisibleRange [

	| insp |
	insp := self newInspectorOn: 'x'.
	5 timesRepeat: [ insp addColumn: (PulsarInspectorModel on: Object new) ].
	self waitForUI.

	self assert: insp visibleRange size equals: 2.
	self assert: insp visibleRange last equals: 6.

	insp shiftRange: -1.
	self waitForUI.
	self assert: insp visibleRange first equals: 4.

	insp moveTo: 1.
	self waitForUI.
	self assert: insp visibleRange last equals: 2
]
