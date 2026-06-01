"
A context to perform repository actions (since the call can be in different places, I need to concentrate them)
"
Class {
	#name : 'PulsarRepositoryActionContext',
	#superclass : 'PulsarActionContext',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'actions' }
PulsarRepositoryActionContext >> doCommit: aModel [

	| commitPresenter dialog |
	commitPresenter := self owner instantiate: PulsarRepositoryCommitDialog.

	(dialog := commitPresenter asModalWindow)
		owner: self window;
		open.
	dialog isOk ifFalse: [ ^ self ].

	commitPresenter message trimBoth ifEmpty: [
			(self application newConfirm
				 title: 'Empty commit message';
				 message: 'Your message is empty. Do you want to commit anyway?';
				 acceptLabel: 'Commit';
				 openModalWithParent: self window) ifFalse: [ ^ self ] ].

	self scheduleJob: [ :statusbar |
			statusbar pushMessage: ('Commiting {1}...' format: { aModel name }).
			aModel newCommitAction
				message: commitPresenter message;
				onSuccess: [ self notifyRepositoryModified: aModel reason: PulsarRepositoryModifiedReason commit ];
				executeWithContext: self owner ]
]

{ #category : 'actions' }
PulsarRepositoryActionContext >> doPull: aModel [

	| remote |
	remote := nil.
	(aModel hasUpstream not or: [ aModel remotes size > 1 ]) ifFalse: [
			remote := self application newSelect
				          title: 'Select remote';
				          message: 'Select remote to pull from (set upstream)';
				          items: (aModel remotes sorted: [ :a | aModel isRemoteUpstream: a ] descending , #name ascending);
				          display: [ :aRemote | aRemote name ];
				          openModalWithParent: self window.
			remote ifNil: [ ^ self ] ].

	self scheduleJob: [ :statusbar |
			statusbar pushMessage: ('Pulling from {1}{2}...' format: {
						 (remote ifNotNil: [ remote name , '/' ] ifNil: [ '' ]).
						 aModel name }).
			(aModel newPullActionFrom: remote)
				onSuccess: [ self notifyRepositoryModified: aModel reason: PulsarRepositoryModifiedReason pull ];
				executeWithContext: self owner ]
]

{ #category : 'actions' }
PulsarRepositoryActionContext >> doPull: aModel intoBranch: aLocalBranchModel [

	| remote |
	remote := nil.
	aModel hasUpstream ifFalse: [
			remote := self application newSelect
				          title: 'Upstream missing';
				          message: 'Select remote to pull from (set upstream)';
				          display: [ :aRemote | aRemote name ];
				          openModalWithParent: self window.
			remote ifNil: [ ^ self ] ].

	self scheduleJob: [ :statusbar |
			statusbar pushMessage: ('Pulling from {1}...' format: { aModel name }).
			(aLocalBranchModel newPullActionFrom: remote)
				onSuccess: [ self notifyRepositoryModified: aModel reason: PulsarRepositoryModifiedReason pull ];
				executeWithContext: self owner ]
]

{ #category : 'actions' }
PulsarRepositoryActionContext >> doPush: aModel [

	| remote |
	remote := nil.
	(aModel hasUpstream not or: [ aModel remotes size > 1 ]) ifTrue: [
			remote := self application newSelect
				          title: 'Select remote';
				          message: 'Select remote to push to (set upstream)';
				          items: (aModel remotes sorted: [ :a | aModel isRemoteUpstream: a ] descending , #name ascending);
				          display: [ :aRemote | aRemote name ];
				          openModalWithParent: self window.
			remote ifNil: [ ^ self ] ].

	self scheduleJob: [ :statusbar |
			statusbar pushMessage: ('Pushing to {1}{2}...' format: {
						 (remote ifNotNil: [ remote name , '/' ] ifNil: [ '' ]).
						 aModel name }).
			(aModel newPushActionTo: remote)
				onSuccess: [ self notifyRepositoryModified: aModel reason: PulsarRepositoryModifiedReason push ];
				executeWithContext: self owner ]
]

{ #category : 'private' }
PulsarRepositoryActionContext >> notifyRepositoryModified: aModel reason: aReason [

	logger trace: aModel.

	self application resendAnnouncement: (PulsarRepositoryModified newValue: aModel reason: aReason)
]
