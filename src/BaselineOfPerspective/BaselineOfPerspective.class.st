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
		spec package: 'Perspective-Method' with: [ spec requires: 'Perspective' ] ]
]

{ #category : 'external projects' }
BaselineOfPerspective >> linden: spec [
	
	spec baseline: 'Linden' with: [ 
		spec repository: 'gitlab://estebanlm/linden' ]

]
