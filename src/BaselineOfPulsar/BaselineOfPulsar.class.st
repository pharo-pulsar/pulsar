Class {
	#name : 'BaselineOfPulsar',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPulsar',
	#package : 'BaselineOfPulsar'
}

{ #category : 'external projects' }
BaselineOfPulsar >> adwaita: spec [
	
	spec baseline: 'Adwaita' with: [ 
		spec repository: 'github://estebanlm/Spec-LibAdwaita:main' ]
]

{ #category : 'baselines' }
BaselineOfPulsar >> baseline: spec [

	<baseline>
	spec for: #common do: [
			self adwaita: spec.
			self vte: spec.
			self linden: spec.
			self mcp: spec.

			spec package: 'Perspective-Spotter' with: [ spec requires: 'Linden' ].
			spec package: 'Perspective' with: [ spec requires: #( 'Adwaita' 'Linden' 'Perspective-Spotter' ) ].
			spec package: 'Perspective-Project' with: [ spec requires: 'Perspective' ].
			spec package: 'Perspective-Package' with: [ spec requires: 'Perspective' ].
			spec package: 'Perspective-Class' with: [ spec requires: 'Perspective' ].
			spec package: 'Perspective-Method' with: [ spec requires: 'Perspective' ]. "base browser & tools"
			spec package: 'Pulsar-Browser' with: [ spec requires: 'Perspective' ]. "non-base tools"
			spec package: 'Pulsar-Tool-Changes' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-Repositories' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-ObjectExplorer' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-FlagsConsole' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-CritiquesConsole' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-Roassal' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-FileEditor' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-TestRunner' with: [ spec requires: 'Pulsar-Browser' ].
			spec package: 'Pulsar-Tool-LLM' with: [ spec requires: #( 'Pulsar-Browser' 'Vte' 'MCP' ) ].
			spec package: 'Pulsar-Tool-TestRunner' with: [ spec requires: 'Pulsar-Browser' ]. "tests"
			spec package: 'Pulsar-Browser-Tests' with: [ spec requires: 'Pulsar-Browser' ] ]
]

{ #category : 'external projects' }
BaselineOfPulsar >> linden: spec [
	
	spec baseline: 'Linden' with: [ 
		spec repository: 'github://estebanlm/linden' ]

]

{ #category : 'external projects' }
BaselineOfPulsar >> mcp: spec [
	
	spec baseline: 'MCP' with: [ 
		spec 
			repository: 'github://estebanlm/MCP:main/src';
			loads: 'MCP' ]
]

{ #category : 'accessing' }
BaselineOfPulsar >> project [

	^ super project
		loadType: #atomic;
		yourself
]

{ #category : 'external projects' }
BaselineOfPulsar >> vte: spec [
	
	spec baseline: 'Vte' with: [ 
		spec repository: 'github://estebanlm/Spec-VTE:main/src' ]

]
