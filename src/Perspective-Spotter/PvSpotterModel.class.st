Class {
	#name : 'PvSpotterModel',
	#superclass : 'StSpotterModel',
	#category : 'Perspective-Spotter-Model',
	#package : 'Perspective-Spotter',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
PvSpotterModel >> candidatesFor: text [
	| candidateList stream context processor |
	
	candidateList := StSpotterCandidatesList new.
	stream := StSpotterStream new 
		receiver: candidateList;
		yourself.

	context:= StSpotterContext new 
		step: self;
		stream: stream;
		text: text;
		search: text;
		yourself.

	{ PvUnifiedProcessor } 
	do: [ :each |
		processor := each newEnvironment: Smalltalk environment.
		processor filterInContext: context ].
	
	^ candidateList candidates asArray
]

{ #category : 'accessing' }
PvSpotterModel >> context [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
PvSpotterModel >> label [

	^ self subclassResponsibility
]
