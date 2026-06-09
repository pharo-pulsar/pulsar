Class {
	#name : 'PulsarCommitInfoPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'authorPresenter',
		'datePresenter',
		'commitIdPresenter',
		'commitMessagePresenter',
		'isVersionLayout',
		'openDiffAction',
		'copyButtonPresenter'
	],
	#category : 'Pulsar-Tool-Repositories-View',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View'
}

{ #category : 'layout' }
PulsarCommitInfoPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		add: commitMessagePresenter;
		add: (SpBoxLayout newHorizontal
			hAlignStart;
			add: authorPresenter;
			add: datePresenter;
			add: (SpBoxLayout newHorizontal
				hAlignStart;
				add: commitIdPresenter;
				add: copyButtonPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'private - actions' }
PulsarCommitInfoPresenter >> doCopyCommitIdToClipboard [

	self model ifNil: [ ^ self ].
	self application copyToClipboard: self model id.
	self withWindowDo: [ :w | w  inform: 'Copied to clipboard' ]
]

{ #category : 'private - actions' }
PulsarCommitInfoPresenter >> doOpenCommitDiff [

	openDiffAction ifNil: [ ^ self].
	openDiffAction value
]

{ #category : 'initialization' }
PulsarCommitInfoPresenter >> initializePresenters [

	self addStyle: 'commitInfo'.

	authorPresenter := self newLabel
		addStyle: 'author';
		yourself.
	
	datePresenter := self newLabel
		addStyle: 'date';
		yourself.
	
	commitIdPresenter := self newLabel
		addStyle: 'pill-commit';
		yourself.
	
	commitMessagePresenter := self newText
		beWrapWord;
		withoutScrollBars;
		propagateNaturalHeight: true;
		beNotEditable;
		yourself.
		
	copyButtonPresenter := self newButton
		addStyle: 'flat';
		addStyle: 'small';
		icon: (self iconNamed: 'copy-to-clipboard');
		help: 'Copy commit id to clipboard';
		action: [ self doCopyCommitIdToClipboard ];
		yourself
]

{ #category : 'private' }
PulsarCommitInfoPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	authorPresenter label: self model normalizedAuthor.
	datePresenter label: self model datetime asLocalStringYMDHM.
	commitIdPresenter label: self model shortId asString.
	commitMessagePresenter text: self model comment trimRight
]

{ #category : 'layout' }
PulsarCommitInfoPresenter >> useVersionLayout [
	self layout: self  versionLayout
]

{ #category : 'layout' }
PulsarCommitInfoPresenter >> versionLayout [

	^ SpBoxLayout newVertical
		add: commitMessagePresenter;
		add: (SpBoxLayout newHorizontal
			hAlignStart;
			add: authorPresenter;
			add: (SpBoxLayout newHorizontal
				hAlignStart;
				add: commitIdPresenter;
				add: copyButtonPresenter;
				"this button here because is layout-specific"
				add: (self newButton
					 addStyle: 'flat';
					 addStyle: 'small';
					 icon: (self iconNamed: 'open');
					 help: 'Open diff for this commit';
					 action: [ self doOpenCommitDiff ];
					 yourself);
				yourself);
			   yourself);
		  yourself
]

{ #category : 'event' }
PulsarCommitInfoPresenter >> whenOpenDiffDo: aBlock [

	openDiffAction := aBlock
]
