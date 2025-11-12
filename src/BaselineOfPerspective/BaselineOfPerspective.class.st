Class {
	#name : 'BaselineOfPerspective',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPerspective',
	#package : 'BaselineOfPerspective'
}

{ #category : 'baselines' }
BaselineOfPerspective >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 

		self linden: spec.
		
		spec package: 'Perspective-Spotter' with: [ spec requires: 'Linden' ]. 
		spec package: 'Perspective' with: [ spec requires: #('Linden' 'Perspective-Spotter') ]. 
		spec package: 'Perspective-Project' with: [ spec requires: 'Perspective' ].
		spec package: 'Perspective-Package' with: [ spec requires: 'Perspective' ].
		spec package: 'Perspective-Class' with: [ spec requires: 'Perspective' ].
		spec package: 'Perspective-Method' with: [ spec requires: 'Perspective' ].
		spec package: 'Dock-Browser' with: [ spec requires: 'Perspective' ].
		spec package: 'Dock-Tool-Changes' with: [ spec requires: 'Dock-Browser' ].
		spec package: 'Dock-Tool-Repositories' with: [ spec requires: 'Dock-Browser' ].
		spec package: 'Dock-Tool-ObjectExplorer' with: [ spec requires: 'Dock-Browser' ].
		spec package: 'Dock-Browser-Tests' with: [ spec requires: 'Dock-Browser' ] ]
]

{ #category : 'external projects' }
BaselineOfPerspective >> linden: spec [
	
	spec baseline: 'Linden' with: [ 
		spec repository: 'gitlab://estebanlm/linden' ]

]
