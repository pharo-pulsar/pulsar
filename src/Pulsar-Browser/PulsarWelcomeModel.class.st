Class {
	#name : 'PulsarWelcomeModel',
	#superclass : 'Object',
	#traits : 'PulsarTModel + PulsarTModelSnapshot',
	#classTraits : 'PulsarTModel classTrait + PulsarTModelSnapshot classTrait',
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

{ #category : 'testing' }
PulsarWelcomeModel >> isSameClass: aClassModel [

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
