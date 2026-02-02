Class {
	#name : 'PulsarWelcomeModel',
	#superclass : 'Object',
	#traits : 'PulsarTModel + PulsarTSnapshot',
	#classTraits : 'PulsarTModel classTrait + PulsarTSnapshot classTrait',
	#category : 'Pulsar-Browser-View-Welcome',
	#package : 'Pulsar-Browser',
	#tag : 'View-Welcome'
}

{ #category : 'accessing' }
PulsarWelcomeModel >> contents [

	^ '


Welcome to Pharo, an immersive live programming environment.

Pharo is a pure object-oriented programming language and a powerful environment, 
focused on simplicity and immediate feedback (think IDE and OS rolled into one).

For more information, please visit here: http://pharo.org	

TODO: Onboarding information here, links to documentation, etc...
'
]

{ #category : 'testing' }
PulsarWelcomeModel >> hasPulsarEditor [

	^ true
]

{ #category : 'accessing' }
PulsarWelcomeModel >> iconName [

	^ 'pharo'
]

{ #category : 'testing' }
PulsarWelcomeModel >> includesClassModel [

	^ false
]

{ #category : 'accessing' }
PulsarWelcomeModel >> name [

	^ 'Welcome to Pharo'
]

{ #category : 'accessing' }
PulsarWelcomeModel >> pulsarEditorClass [

	^ PulsarWelcomeView
]

{ #category : 'accessing' }
PulsarWelcomeModel >> realModel [

	^ self
]
