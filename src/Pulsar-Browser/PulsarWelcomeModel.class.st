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


Welcome to Pulsar - The alternative IDE for Pharo Smalltalk.

Pharo is a pure object-oriented programming language and a powerful environment, 
focused on simplicity and immediate feedback (think IDE and OS rolled into one).

### The Sandbox

Your workspace starts with a **Sandbox** project in the **Projects** pane on the
left sidebar. It is a *volatile project* — not tied to a Metacello baseline — built
for quick exploration. It comes with a `Sandbox` package ready for your classes.
Close it and it cleans itself up; create classes in it and it stays.

### Creating and opening projects

Use the **Projects** pane toolbar or context menu:

- **New project** — Creates a fresh volatile project with an auto-generated package.
  Ideal for prototyping.

- **Open baseline project** — Opens an existing Metacello project with full
  dependency management.

### Next steps

- Create a class inside the `Sandbox` package to explore the Pulsar tools
- Visit [pharo.org](https://pharo.org) for documentation and tutorials
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
