Class {
	#name : 'PulsarRepositoryPackageModel',
	#superclass : 'PulsarRepositoryBaseModel',
	#category : 'Pulsar-Tool-Repositories-Model',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'Model'
}

{ #category : 'instance creation' }
PulsarRepositoryPackageModel class >> on: aPackage [

	^ self basicNew
		package: aPackage;
		initialize;
		yourself
]

{ #category : 'accessing - actions' }
PulsarRepositoryPackageModel >> actionsWithContextOn: aContextPresenter [

	^ (self actions actionsForAll: #(baseline package)) copyWithContext: aContextPresenter
]

{ #category : 'accessing' }
PulsarRepositoryPackageModel >> baselineName [

	^ self name allButFirst: 10 "BaselineOf"
]

{ #category : 'private - definitions' }
PulsarRepositoryPackageModel >> defineBaselineActionsOn: aBuilder [
	<dockActions>
	
	self isBaseline ifFalse: [ ^ self ].
	
	aBuilder addGroup: #baseline with: [ :group | 
		group 
			priority: 1;
			name: 'Metacello';
			beDisplayedAsSubMenu.
			
		group addActionWith: [ :action | action 
			priority: 1;
			name: ('Install {1}' format: { self baselineName });
			description: 'Install baseline';
			action: [ :aContext | aContext doInstallBaseline: self ].
		
		self isBaselineLocked 
			ifTrue: [ 
				group addActionWith: [ :action | action 
					priority: 100;
					name: ('Unlock {1}' format: { self baselineName });
					description: 'Unlock baseline';
					action: [ :aContext | aContext doUnlockBaseline: self ] ] ]
			ifFalse: [ 
				group addActionWith: [ :action | action 
					name: ('Lock {1}' format: { self baselineName });
					priority: 100;
					description: 'Lock baseline';
					action: [ :aContext | aContext doLockBaseline: self ] ] ] ] ].
]

{ #category : 'private - definitions' }
PulsarRepositoryPackageModel >> definePackageActionsOn: aBuilder [
	<dockActions>
	
	aBuilder addGroup: #package with: [ :group | 
		self isLoaded 
			ifTrue: [ 
				group 
					addActionWith: [ :action | action 
						name: ('Unload {1}' format: { self name });
						description: 'Unload package';
						action: [ :aContext | aContext doUnloadPackage: self ] ];
					addActionWith: [ :action | action 
						name: ('Reload {1}' format: { self name });
						description: 'Reload package';
						action: [ :aContext | aContext doReloadPackage: self ] ] ]
			ifFalse: [
				group 
					addActionWith: [ :action | action 
						name: ('Load {1}' format: { self name });
						description: 'Load package';
						action: [ :aContext | aContext doLoadPackage: self ] ] ] ].
]

{ #category : 'actions' }
PulsarRepositoryPackageModel >> installBaselineGroups: aCollection upgradePolicy: upgradePolicy conflictPolicy: conflictPolicy [
	| packageDir sourceDirectory |
	
	sourceDirectory := self repository project sourceDirectory.
	sourceDirectory ifEmpty: [ sourceDirectory := '.'].

	packageDir := (self repository location / sourceDirectory) fullName.
	Metacello new
		repository: 'gitlocal://', packageDir;
		baseline: self baselineName;
		onUpgrade: [ :e |e perform: upgradePolicy ];
		onConflict: [ :e | e perform: conflictPolicy ];
		load: aCollection
]

{ #category : 'testing' }
PulsarRepositoryPackageModel >> isBaseline [

	^ self name beginsWith: 'BaselineOf'
]

{ #category : 'testing' }
PulsarRepositoryPackageModel >> isBaselineLocked [

	^ (MetacelloProjectRegistration 
		projectSpecForClassNamed: self package name 
		ifAbsent: [ ^ false ])
		isLocked
]

{ #category : 'testing' }
PulsarRepositoryPackageModel >> isLoaded [

	^ self repository isPackageLoaded: self
]

{ #category : 'actions' }
PulsarRepositoryPackageModel >> load [

	self entity load
]

{ #category : 'accessing' }
PulsarRepositoryPackageModel >> name [

	^ self package name
]

{ #category : 'accessing' }
PulsarRepositoryPackageModel >> package [

	^ self entity
]
