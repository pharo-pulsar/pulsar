Class {
	#name : 'DockProjectNodeRow',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'imagePresenter',
		'labelPresenter'
	],
	#category : 'Dock-Browser-View-Project',
	#package : 'Dock-Browser',
	#tag : 'View-Project'
}

{ #category : 'layout' }
DockProjectNodeRow >> defaultLayout [

	^ SpBoxLayout newHorizontal
		add: imagePresenter expand: false;
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
DockProjectNodeRow >> initializePresenters [

	imagePresenter := self newImage.
	labelPresenter := self newLabel
]

{ #category : 'initialization' }
DockProjectNodeRow >> updatePresenter [

	self model ifNil: [ ^ self ].
	
	imagePresenter image: (self iconNamed: (self model iconName ifNil: [ #blank ])).
	labelPresenter label: self model name.
	
	"self model isManagedAndModified
		ifTrue: [ labelPresenter addStyle: 'modified' ]
		ifFalse: [ labelPresenter removeStyle: 'modified' ]"
]
