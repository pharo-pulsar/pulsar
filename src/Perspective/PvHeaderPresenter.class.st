Class {
	#name : #PvHeaderPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'titleLabel',
		'image',
		'contentPresenter'
	],
	#category : #'Perspective-View-Header'
}

{ #category : #accessing }
PvHeaderPresenter >> content: aPresenter [

	contentPresenter := aPresenter
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
		yourself
]

{ #category : #accessing }
PvHeaderPresenter >> label: aString [

	titleLabel label: aString
]

{ #category : #updating }
PvHeaderPresenter >> updateFrom: aWindowPresenter [

	self image: aWindowPresenter windowIcon.
	self label: aWindowPresenter title
]
