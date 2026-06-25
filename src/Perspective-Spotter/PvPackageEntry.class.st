"
I am a Pulsar-aware package entry for the spotter.

I extend StPackageEntry to activate PvPackageModel when selected, following the same pattern as PvClassEntry and PvMethodEntry.
"
Class {
	#name : 'PvPackageEntry',
	#superclass : 'StPackageEntry',
	#category : 'Perspective-Spotter-Model-Entry',
	#package : 'Perspective-Spotter',
	#tag : 'Model-Entry'
}

{ #category : 'accessing' }
PvPackageEntry >> accept: aSpotter [

	aSpotter visitPackageEntry: self
]
