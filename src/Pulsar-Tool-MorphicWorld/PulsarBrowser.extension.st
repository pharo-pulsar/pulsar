Extension { #name : 'PulsarBrowser' }

{ #category : '*Pulsar-Tool-MorphicWorld' }
PulsarBrowser >> defineDevelopmentToolsActionsOn: aBuilder [
	<dockActions>

	"this actions are just possible in linux"
	OSPlatform current isLinux ifFalse: [ ^ self ].
	
	aBuilder addAll: (PulsarMorphicWorldActivator uniqueInstance actions entries)
]
