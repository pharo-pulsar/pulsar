Class {
	#name : 'PulsarSpotterModel',
	#superclass : 'PvSpotterModelForEnvironment',
	#category : 'Pulsar-Browser-Tool-Spotter',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Spotter'
}

{ #category : 'as yet unclassified' }
PulsarSpotterModel >> candidatesFor: text inContext: aPulsarSpotterContext [
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

	(self processorsForContext: aPulsarSpotterContext) do: [ :each |
		processor := each newEnvironment: Smalltalk environment.
		processor prepareFor: aPulsarSpotterContext.
		processor filterInContext: context ].
	
	^ candidateList candidates asArray
]

{ #category : 'private' }
PulsarSpotterModel >> processorsForContext: aContext [

	^ aContext associatedProcessors
]
