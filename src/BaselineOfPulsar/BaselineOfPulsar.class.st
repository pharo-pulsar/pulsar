Class {
	#name : 'BaselineOfPulsar',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPulsar',
	#package : 'BaselineOfPulsar'
}

{ #category : 'baselines' }
BaselineOfPulsar >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 

		self linden: spec.
		
		spec package: 'Perspective-Spotter' with: [ spec requires: 'Linden' ]. 
		spec package: 'Perspective' with: [ spec requires: #('Linden' 'Perspective-Spotter') ]. 
		spec package: 'Perspective-Project' with: [ spec requires: 'Perspective' ].
		spec package: 'Perspective-Package' with: [ spec requires: 'Perspective' ].
		spec package: 'Perspective-Class' with: [ spec requires: 'Perspective' ].
		spec package: 'Perspective-Method' with: [ spec requires: 'Perspective' ].
		spec package: 'Pulsar-Browser' with: [ spec requires: 'Perspective' ].
		spec package: 'Pulsar-Tool-Changes' with: [ spec requires: 'Pulsar-Browser' ].
		spec package: 'Pulsar-Tool-Repositories' with: [ spec requires: 'Pulsar-Browser' ].
		spec package: 'Pulsar-Tool-ObjectExplorer' with: [ spec requires: 'Pulsar-Browser' ].
		spec package: 'Pulsar-Tool-FlagsConsole' with: [ spec requires: 'Pulsar-Browser' ].
		spec package: 'Pulsar-Tool-CritiquesConsole' with: [ spec requires: 'Pulsar-Browser' ].
		spec package: 'Pulsar-Tool-Roassal' with: [ spec requires: 'Pulsar-Browser' ].
		spec package: 'Pulsar-Browser-Tests' with: [ spec requires: 'Pulsar-Browser' ] ]
]

{ #category : 'external projects' }
BaselineOfPulsar >> linden: spec [
	
	spec baseline: 'Linden' with: [ 
		spec repository: 'gitlab://estebanlm/linden' ]

]

{ #category : 'accessing' }
BaselineOfPulsar >> project [

	^ super project
		loadType: #atomic;
		yourself
]
