Class {
	#name : 'DockSpotterModel',
	#superclass : 'PvSpotterModelForEnvironment',
	#category : 'Dock-Browser-Tool-Spotter',
	#package : 'Dock-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'as yet unclassified' }
DockSpotterModel >> candidatesFor: text inContext: aContext [
	"contextSymbol can be #environment, #editors, #tools"
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

	(self processorsForContext: aContext) do: [ :each |
		processor := each newEnvironment: Smalltalk environment.
		processor filterInContext: context ].
	
	^ candidateList candidates asArray
]

{ #category : 'private' }
DockSpotterModel >> processorsForContext: aContext [

	^ aContext associatedProcessors
]
