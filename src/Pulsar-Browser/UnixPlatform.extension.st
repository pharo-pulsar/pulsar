Extension { #name : 'UnixPlatform' }

{ #category : '*Pulsar-Browser' }
UnixPlatform >> isFlatpak [

	^ (self environmentVariableNamed: 'FLATPAK_ID' ifAbsent: [ nil ]) notNil
]
