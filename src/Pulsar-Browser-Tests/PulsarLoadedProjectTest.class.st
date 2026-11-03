Class {
	#name : 'PulsarLoadedProjectTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'tests' }
PulsarLoadedProjectTest >> testAccessors [

	| project |
	project := PulsarLoadedProject new
		name: 'Pulsar';
		baselineName: 'BaselineOfPulsar';
		packageNames: #('Perspective' 'Pulsar-Browser');
		origin: '/repo/Pulsar';
		version: 'abc123';
		yourself.
	self assert: project name equals: 'Pulsar'.
	self assert: project baselineName equals: 'BaselineOfPulsar'.
	self assert: project packageNames size equals: 2.
	self assert: project origin equals: '/repo/Pulsar'.
	self assert: project version equals: 'abc123'
]

{ #category : 'tests' }
PulsarLoadedProjectTest >> testEquality [

	| one another different |
	one := PulsarLoadedProject new name: 'X'; origin: '/repo/X'; yourself.
	another := PulsarLoadedProject new name: 'X'; origin: '/repo/X'; yourself.
	different := PulsarLoadedProject new name: 'X'; origin: '/repo/Y'; yourself.
	self assert: one equals: another.
	self assert: one hash equals: another hash.
	self deny: one equals: different
]

{ #category : 'tests' }
PulsarLoadedProjectTest >> testIsResolvedRequiresRepository [

	| project |
	project := PulsarLoadedProject new name: 'X'; yourself.
	self deny: project isResolved.
	project repository: Object new.
	self assert: project isResolved
]

{ #category : 'tests' }
PulsarLoadedProjectTest >> testPackageNamesDefaultToEmpty [

	self assert: PulsarLoadedProject new packageNames isEmpty
]
