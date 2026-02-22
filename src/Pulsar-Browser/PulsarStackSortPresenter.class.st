"
A presenter to self-contain sorting actions for `PulsarStackView`
"
Class {
	#name : 'PulsarStackSortPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel + PulsarTActionContainer',
	#classTraits : 'SpTModel classTrait + PulsarTActionContainer classTrait',
	#instVars : [
		'menuButtonPresenter'
	],
	#category : 'Pulsar-Browser-View-Stack',
	#package : 'Pulsar-Browser',
	#tag : 'View-Stack'
}

{ #category : 'layout' }
PulsarStackSortPresenter >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: menuButtonPresenter;
		yourself
]

{ #category : 'private - definitions' }
PulsarStackSortPresenter >> defineSortActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #group with: [ :group | group
		addActionWith: [ :action | action
			name: 'Sort by open time';
			state: (self model isSortingBy: #firstActivationTime);
			action: [
				self toggleAction: action inGroup: group.
				self model doSortBy: #firstActivationTime ] ];
		addActionWith: [ :action | action 
			name: 'Sort by last focus time';
			state: (self model isSortingBy: #lastActivationTime);
			action: [ 
				self toggleAction: action inGroup: group.
				self model doSortBy: #lastActivationTime ] ] ]
]

{ #category : 'initialization' }
PulsarStackSortPresenter >> initializePresenters [

	menuButtonPresenter := self newMenuButton
		addStyle: 'flat'; 
		icon: (self iconNamed: #sort);
		help: 'Select sorting of opened editors';
		actions: self actions;
		yourself
]

{ #category : 'private' }
PulsarStackSortPresenter >> toggleAction: anAction inGroup: aGroup [
	
	aGroup entries do: [ :each | each state: false ].
	anAction state: true
]
