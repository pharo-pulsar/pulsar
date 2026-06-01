Extension { #name : 'WinPlatform' }

{ #category : '*Pulsar-Browser' }
WinPlatform >> executableExtensions [

	^ OrderedCollection new
		add: '';
		addAll: ((self environmentVariableNamed: 'PATHEXT' ifAbsent: [ nil ])
			ifNotNil: [ :extensions | extensions substrings: ';' ]
			ifNil: [ #( '.com' '.exe' '.bat' '.cmd' ) ]);
		yourself
]
