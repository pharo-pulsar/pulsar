"
tags are not branches, clearly.
but they behave en many ways like one...
"
Class {
	#name : 'PulsarRepositoryTagBranchView',
	#superclass : 'PulsarRepositoryBaseBranchView',
	#category : 'Pulsar-Tool-Repositories-View-Branches',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Branches'
}

{ #category : 'private' }
PulsarRepositoryTagBranchView >> branches [

	^ self model tags
]

{ #category : 'private - definitions' }
PulsarRepositoryTagBranchView >> defineExtraActionOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #extra with: [ :group | group
		addActionWith: [ :action | action
			dynamicName: 'Add tag';
			description: 'Add a tag on current commit';
			iconName: 'add';
			action: [ self doAddTagCommand: action ] ] ]
]

{ #category : 'private - actions' }
PulsarRepositoryTagBranchView >> doAddTagCommand: aCommand [
	| dialog protocolName |

	dialog := self instantiate: PulsarRequestPresenter.
	dialog label: 'Tag Name'.
	dialog acceptLabel: 'Add'.
	
	dialog asPopover
		relativeTo: aCommand presenter;
		popupModalAndWait.
	dialog isOk ifFalse: [ ^ self ].
	
	protocolName := dialog text.
	self scheduleJob: [ 
		self model addTag: protocolName.
		self updatePresenter ]
]

{ #category : 'initialization' }
PulsarRepositoryTagBranchView >> initializePresenters [

	super initializePresenters.
	
	toolbarPresenter addPresenter: (self newToolbar 
		beIcons;
		fillWith: (self actions actionsFor: #extra))
]

{ #category : 'accessing' }
PulsarRepositoryTagBranchView >> label [

	^ 'tags'
]

{ #category : 'private' }
PulsarRepositoryTagBranchView >> maybeSort: aCollection [

	^ aCollection sort: #isHead descending,  #datetime descending
]
