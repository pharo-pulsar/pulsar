Class {
	#name : #PvHeaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel',
		'closeButton',
		'image',
		'contentPresenter'
	],
	#category : #'NewTools-PerspectiveBrowser-View-Header-REMOVE'
}

{ #category : #accessing }
PvHeaderPresenter >> content: aPresenter [

	contentPresenter := aPresenter.
	contentPresenter initializeToolbar: toolbar
]

{ #category : #actions }
PvHeaderPresenter >> delete [

	contentPresenter delete
]

{ #category : #accessing }
PvHeaderPresenter >> image: anImage [

	image image: anImage
]

{ #category : #initialization }
PvHeaderPresenter >> initializePresenters [

	layout := SpBoxLayout newHorizontal
		beNotHomogeneous;
		borderWidth: 3;
		spacing: 3;
		add: (image := self newImage) expand: false;
		add: (titleLabel := self newLabel);
		addLast: (toolbar := self newToolbar) expand: false;
		yourself.
		
	"closeButton 
		addStyle: 'flat';
		""addStyle: 'circular';""
		icon:  (self application iconNamed: 'gtk-close');
		action: [ self delete ]"
]

{ #category : #accessing }
PvHeaderPresenter >> label: aString [

	titleLabel label: aString
]

{ #category : #initialization }
PvHeaderPresenter >> toolbar [
		
	^ toolbar
]

{ #category : #updating }
PvHeaderPresenter >> updateFrom: aWindowPresenter [

	self image: aWindowPresenter taskbarIcon.
	self label: aWindowPresenter title.
]
