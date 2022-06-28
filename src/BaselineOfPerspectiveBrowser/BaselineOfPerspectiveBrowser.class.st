Class {
	#name : #BaselineOfPerspectiveBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfPerspectiveBrowser
}

{ #category : #baselines }
BaselineOfPerspectiveBrowser >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		self linden: spec.
		spec package: 'NewTools-PerspectiveBrowser' with: [ spec requires: 'Linden' ] ]
]

{ #category : #baselines }
BaselineOfPerspectiveBrowser >> linden: spec [
	
	spec baseline: 'Linden' with: [ 
		spec repository: 'gitlab://estebanlm/linden' ]

]
