"
Visits IceDefinitions to populate a PulsarBreadcrumbPresenter with breadcrumb segments for the Pulsar diff editor cards.
"
Class {
	#name : 'PulsarDiffBreadcrumbBuilder',
	#superclass : 'Object',
	#instVars : [
		'breadcrumb',
		'diffNode',
		'notificationCenter'
	],
	#category : 'Pulsar-Tool-Repositories-View-Editor',
	#package : 'Pulsar-Tool-Repositories',
	#tag : 'View-Editor'
}

{ #category : 'private' }
PulsarDiffBreadcrumbBuilder >> addClassLinkNamed: aClassName [

	(diffNode canBeActivated and: [ notificationCenter isNotNil ]) ifTrue: [
			breadcrumb addLinkSegment: aClassName action: [ notificationCenter announce: diffNode newClassModel newActivationAnnouncement ].
			^ self ].

	breadcrumb addSegment: (breadcrumb newLabel
			 label: aClassName;
			 yourself)
]

{ #category : 'private' }
PulsarDiffBreadcrumbBuilder >> addMethodLinkForSelector: aSelector [

	logger debug: diffNode canBeActivated.
	logger debug: notificationCenter.

	(diffNode canBeActivated and: [ notificationCenter isNotNil ]) ifTrue: [
		breadcrumb 
			addLinkSegment: aSelector 
			action: [ notificationCenter announce: diffNode newMethodModel newActivationAnnouncement ].
		^ self ].

	breadcrumb addSegment: (breadcrumb newLabel
		 label: aSelector;
		 yourself)
]

{ #category : 'private' }
PulsarDiffBreadcrumbBuilder >> addSegmentNamed: aString [

	breadcrumb addSegment: (breadcrumb newLabel
			 label: aString;
			 yourself)
]

{ #category : 'accessing' }
PulsarDiffBreadcrumbBuilder >> breadcrumb [

	^ breadcrumb
]

{ #category : 'accessing' }
PulsarDiffBreadcrumbBuilder >> breadcrumb: aPulsarBreadcrumbPresenter [

	breadcrumb := aPulsarBreadcrumbPresenter
]

{ #category : 'building' }
PulsarDiffBreadcrumbBuilder >> buildFrom: anIceDefinition [

	anIceDefinition accept: self
]

{ #category : 'accessing' }
PulsarDiffBreadcrumbBuilder >> diffNode [

	^ diffNode
]

{ #category : 'accessing' }
PulsarDiffBreadcrumbBuilder >> diffNode: aPulsarDiffNode [

	diffNode := aPulsarDiffNode
]

{ #category : 'accessing' }
PulsarDiffBreadcrumbBuilder >> notificationCenter [

	^ notificationCenter
]

{ #category : 'accessing' }
PulsarDiffBreadcrumbBuilder >> notificationCenter: anAnnouncer [

	notificationCenter := anAnnouncer
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitClassDefinition: aDefinition [

	self addClassLinkNamed: aDefinition name
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitDirectoryDefinition: aDefinition [

	self addSegmentNamed: aDefinition name
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitEmptyNode: aDefinition [

	self addSegmentNamed: aDefinition name
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitExtensionDefinition: aDefinition [
	"Extension definition name is the class name; treat it as a class link."

	self addClassLinkNamed: aDefinition name
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitFileNode: aDefinition [

	self addSegmentNamed: aDefinition name
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitMethodNode: aDefinition [

	self addSegmentNamed: aDefinition className.
	self addMethodLinkForSelector: aDefinition selector
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitPackage: aDefinition [

	self addSegmentNamed: aDefinition name
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitRootDefinition: aDefinition [
	"Root has no meaningful name."

	
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitTraitDefinition: aDefinition [

	self addClassLinkNamed: aDefinition name
]

{ #category : 'visiting' }
PulsarDiffBreadcrumbBuilder >> visitTreeNode: aNode [

	aNode definition ifNotNil: [ :def | def accept: self ]
]
