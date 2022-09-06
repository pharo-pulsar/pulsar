Class {
	#name : #PvContextActionBuilder,
	#superclass : #Object,
	#instVars : [
		'fromCommandClass',
		'actionGroups',
		'mainGroups',
		'owner'
	],
	#category : #'Perspective-View'
}

{ #category : #'instance creation' }
PvContextActionBuilder class >> on: aPresenter [

	^ self new 
		owner: aPresenter;
		yourself
]

{ #category : #accessing }
PvContextActionBuilder >> actionGroup: aSymbol [

	actionGroups := aSymbol
]

{ #category : #accessing }
PvContextActionBuilder >> actionGroups [

	^ actionGroups ifNil: [ #() ]
]

{ #category : #accessing }
PvContextActionBuilder >> actionGroups: anArray [

	actionGroups := anArray
]

{ #category : #building }
PvContextActionBuilder >> buildToolbar [
	| presenter |

	presenter := self owner newPresenter.
	presenter layout: SpBoxLayout newLeftToRight.	
	
	presenter layout add: (presenter newToolbar
		addStyle: 'pvPerspectiveToolbar';
		displayMode: self owner application toolbarDisplayMode;
		fillWith: (self fromCommandClass 
			buildToolbar: self mainGroups 
			on: self owner)).
			
	self actionGroups ifNotEmpty: [
		presenter layout 
			addLast: (presenter newButton
				addStyle: 'small';
				addStyle: 'flat';
				icon: ((PvCompositeIcon newName: 'view-more-symbolic') buildOn: self owner application);
				action: [ ];
				yourself)
			expand: false
		"presenter layout 
			addLast: (presenter newToolbar
				addStyle: 'pvPerspectiveToolbar';
				displayMode: self owner application toolbarDisplayMode;
				fillWith: (self fromCommandClass 
					buildToolbar: self actionGroups 
					on: self owner))
			expand: false" ].

	^ presenter
]

{ #category : #building }
PvContextActionBuilder >> buildToolbarWith: aBlock [

	aBlock value: self.
	^ self buildToolbar
]

{ #category : #accessing }
PvContextActionBuilder >> from: aCommandClass [

	fromCommandClass := aCommandClass
]

{ #category : #accessing }
PvContextActionBuilder >> fromCommandClass [

	^ fromCommandClass ifNil: [ PvCommand ]
]

{ #category : #accessing }
PvContextActionBuilder >> mainGroup: aSymbol [

	mainGroups := aSymbol
]

{ #category : #accessing }
PvContextActionBuilder >> mainGroups [

	^ mainGroups ifNil: [ #(default) ]
]

{ #category : #accessing }
PvContextActionBuilder >> mainGroups: anArray [

	mainGroups := anArray
]

{ #category : #accessing }
PvContextActionBuilder >> owner [

	^ owner
]

{ #category : #accessing }
PvContextActionBuilder >> owner: aPresenter [

	owner := aPresenter
]
