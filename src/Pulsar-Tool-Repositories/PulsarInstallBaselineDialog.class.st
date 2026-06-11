Class {
	#name : 'PulsarInstallBaselineDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'groupsTextPresenter',
		'upgradeUseLoadedPresenter',
		'upgradeUseIncomingPresenter',
		'conflictUseLoadedPresenter',
		'conflictUseIncomingPresenter',
		'packageModel',
		'ignoreImagePresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'accessing' }
PulsarInstallBaselineDialog >> conflictPolicy [

	^ conflictUseLoadedPresenter state 
		ifTrue: [ #useLoaded ]
		ifFalse: [ #useIncoming ]
]

{ #category : 'api - focus' }
PulsarInstallBaselineDialog >> defaultKeyboardFocus [
	
	^ groupsTextPresenter
]

{ #category : 'layout' }
PulsarInstallBaselineDialog >> defaultLayout [

	^ SpBoxLayout newVertical
		add: 'Group(s) to install (comma separated)' expand: false;
		add: groupsTextPresenter expand: false;
		add: (SpBoxLayout newHorizontal
			add: (SpFrameLayout new
				label: 'Upgrade policy';
				add: (SpBoxLayout newVertical
					add: upgradeUseLoadedPresenter;
					add: upgradeUseIncomingPresenter;
					yourself);
				yourself);
			add: (SpFrameLayout new
					label: 'Conflict policy';
					child: (SpBoxLayout newVertical
						add: conflictUseLoadedPresenter;
						add: conflictUseIncomingPresenter;
						yourself);
				yourself);
			yourself);
		add: ignoreImagePresenter expand: false;
		yourself
]

{ #category : 'accessing' }
PulsarInstallBaselineDialog >> groups [

	^ (groupsTextPresenter text substrings: ',') collect: [ :each | each trimBoth ]
]

{ #category : 'accessing' }
PulsarInstallBaselineDialog >> ignoreImage [

	^ ignoreImagePresenter state
]

{ #category : 'initialization' }
PulsarInstallBaselineDialog >> initializeDialogWindow: aDialogWindowPresenter [
	
	aDialogWindowPresenter
		addButton: 'Cancel' do: [ :presenter | 
			presenter triggerCancelAction.
			presenter close ];
		addDefaultButton: 'Install' do: [ :presenter | 
			presenter triggerOkAction.
			presenter beOk.
			presenter close ]
]

{ #category : 'initialization' }
PulsarInstallBaselineDialog >> initializePresenters [

	self addStyle: 'pulsarDialog'.	

	groupsTextPresenter := self newTextInput.
	
	upgradeUseLoadedPresenter := self newRadioButton
		label: 'Use loaded';
		yourself.
	upgradeUseIncomingPresenter := self newRadioButton
		label: 'Use incoming';
		yourself.	
	upgradeUseLoadedPresenter associatedRadioButtons: { upgradeUseIncomingPresenter }.

	conflictUseLoadedPresenter := self newRadioButton
		label: 'Use loaded';
		yourself.
	conflictUseIncomingPresenter := self newRadioButton
		label: 'Use incoming';
		yourself.	
	conflictUseLoadedPresenter associatedRadioButtons: { conflictUseIncomingPresenter }.
	
	ignoreImagePresenter := self newCheckBox
		label: 'Ignore image';
		yourself
]

{ #category : 'initialization' }
PulsarInstallBaselineDialog >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: ('Install Baseline', (self packageModel
			ifNotNil: [ :aModel | ': ', aModel baselineName ]
			ifNil: [ '' ]));
		initialExtent: 500@320
]

{ #category : 'testing' }
PulsarInstallBaselineDialog >> isIgnoreImage [

	^ ignoreImagePresenter state
]

{ #category : 'accessing' }
PulsarInstallBaselineDialog >> packageModel [

	^ packageModel
]

{ #category : 'accessing' }
PulsarInstallBaselineDialog >> packageModel: aPackageModel [

	packageModel := aPackageModel
]

{ #category : 'initialization' }
PulsarInstallBaselineDialog >> updatePresenter [

	groupsTextPresenter text: 'default'; selectAll.
	upgradeUseLoadedPresenter state: true.
	conflictUseLoadedPresenter state: true
]

{ #category : 'accessing' }
PulsarInstallBaselineDialog >> upgradePolicy [

	^ upgradeUseLoadedPresenter state 
		ifTrue: [ #useLoaded ]
		ifFalse: [ #useIncoming ]
]
