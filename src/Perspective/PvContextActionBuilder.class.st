Class {
	#name : 'PvContextActionBuilder',
	#superclass : 'Object',
	#instVars : [
		'fromCommandClass',
		'actionGroups',
		'mainGroups',
		'owner'
	],
	#category : 'Perspective-View',
	#package : 'Perspective',
	#tag : 'View'
}

{ #category : 'instance creation' }
PvContextActionBuilder class >> on: aPresenter [

	^ self new 
		owner: aPresenter;
		yourself
]

{ #category : 'accessing' }
PvContextActionBuilder >> actionGroup: aSymbol [

	actionGroups := { aSymbol }
]

{ #category : 'accessing' }
PvContextActionBuilder >> actionGroups [

	^ actionGroups ifNil: [ #() ]
]

{ #category : 'accessing' }
PvContextActionBuilder >> actionGroups: anArray [

	actionGroups := anArray
]

{ #category : 'private' }
PvContextActionBuilder >> addActionsMenuTo: presenter [
	| actionsMenuCommandGroup |

	actionsMenuCommandGroup := self buildActionsMenuCommandGroup.
	presenter layout 
		addLast: (presenter newMenuButton
			addStyle: 'small';
			addStyle: 'flat';
			icon: ((PvCompositeIcon newName: 'view-more-symbolic') buildOn: self owner application);
			enabled: actionsMenuCommandGroup allCommands notEmpty;
			menu: [ actionsMenuCommandGroup asMenuPresenter ];
			yourself)
		expand: false
]

{ #category : 'private' }
PvContextActionBuilder >> addToolbarTo: presenter [
	| toolbarCommandGroup |
	
	toolbarCommandGroup := self buildToolbarCommandGroup.
	toolbarCommandGroup allCommands ifEmpty: [ ^ self ].
	 
	presenter layout add: (presenter newToolbar
		addStyle: 'pvPerspectiveToolbar';
		displayMode: self owner application toolbarDisplayMode;
		fillWith: toolbarCommandGroup)
]

{ #category : 'private' }
PvContextActionBuilder >> buildActionsMenuCommandGroup [
	
	^ self fromCommandClass 
		buildMenu: self actionGroups 
		on: self owner
]

{ #category : 'building' }
PvContextActionBuilder >> buildToolbar [
	| presenter |

	presenter := self owner newPresenter.
	presenter layout: SpBoxLayout newLeftToRight.	

	self addToolbarTo: presenter.
	self actionGroups ifNotEmpty: [
		self addActionsMenuTo: presenter ].

	^ presenter
]

{ #category : 'private' }
PvContextActionBuilder >> buildToolbarCommandGroup [
	
	^ self fromCommandClass 
		buildToolbar: self mainGroups 
		on: self owner
]

{ #category : 'building' }
PvContextActionBuilder >> buildToolbarWith: aBlock [

	aBlock value: self.
	^ self buildToolbar
]

{ #category : 'accessing' }
PvContextActionBuilder >> from: aCommandClass [

	fromCommandClass := aCommandClass
]

{ #category : 'accessing' }
PvContextActionBuilder >> fromCommandClass [

	^ fromCommandClass ifNil: [ SpAction ]
]

{ #category : 'accessing' }
PvContextActionBuilder >> mainGroup: aSymbol [

	mainGroups := { aSymbol }
]

{ #category : 'accessing' }
PvContextActionBuilder >> mainGroups [

	^ mainGroups ifNil: [ #(default) ]
]

{ #category : 'accessing' }
PvContextActionBuilder >> mainGroups: anArray [

	mainGroups := anArray
]

{ #category : 'accessing' }
PvContextActionBuilder >> owner [

	^ owner
]

{ #category : 'accessing' }
PvContextActionBuilder >> owner: aPresenter [

	owner := aPresenter
]
