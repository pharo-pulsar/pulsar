"
""A helper that creates a BaselineOf class for a volatile project in Pulsar.

Given a project name and the package names it contains, it produces the
BaselineOf<Name> class whose #baseline: method lists those packages flat.
It also detects when the baseline already exists so callers can propose
an override.""
"
Class {
	#name : 'PulsarBaselineCreator',
	#superclass : 'Object',
	#instVars : [
		'name',
		'packageNames'
	],
	#category : 'Pulsar-Browser-View-Project',
	#package : 'Pulsar-Browser',
	#tag : 'View-Project'
}

{ #category : 'instance creation' }
PulsarBaselineCreator class >> fromProject: aProjectModel [
	
	^ self new fromProject: aProjectModel
]

{ #category : 'accessing' }
PulsarBaselineCreator >> baselineClass [

	^ Smalltalk classNamed: self baselineName
]

{ #category : 'private' }
PulsarBaselineCreator >> baselineMethodSource [
	"Build the #baseline: source listing the project packages flat."

	^ String streamContents: [ :stream | stream
		nextPutAll: 'baseline: spec'; cr;
	  	tab; nextPutAll: '<baseline>'; cr;
	  	cr;
	  	tab; nextPutAll: 'spec for: #common do: ['; cr.
	  	
	  	self packageNames 
	  		do: [ :each | 
	  			stream tab; tab; nextPutAll: ('spec package: ''{1}''' format: { each }) ]
	  		separatedBy: [ 
	  			stream cr ].
	  	
	 	stream  
	 		cr;
	  		tab; nextPutAll: ']' ]
]

{ #category : 'accessing' }
PulsarBaselineCreator >> baselineName [

	^ ('BaselineOf' , name) asSymbol
]

{ #category : 'generating' }
PulsarBaselineCreator >> ensureBaseline [
	"Create the baseline class if absent and compile the #baseline: method."
	| baselineClass |
	
	baselineClass := self baselineClass 
		ifNil: [ self installBaseline  ].
	
	baselineClass 
		compile: self baselineMethodSource 
		classified: 'baselines'.
	
	^ baselineClass
]

{ #category : 'testing' }
PulsarBaselineCreator >> exists [

	^ self baselineClass isNotNil
]

{ #category : 'initialization' }
PulsarBaselineCreator >> fromProject: aProjectModel [ 

	self
		name: aProjectModel name;
		packageNames: (aProjectModel packageModels collect: #name)
]

{ #category : 'private' }
PulsarBaselineCreator >> installBaseline [

	^ (BaselineOf << self baselineName)
		package: self baselineName;
		install
]

{ #category : 'accessing' }
PulsarBaselineCreator >> name: aName [

	name := aName
]

{ #category : 'accessing' }
PulsarBaselineCreator >> packageNames [

	^ packageNames
]

{ #category : 'accessing' }
PulsarBaselineCreator >> packageNames: aCollection [

	packageNames := aCollection
]
