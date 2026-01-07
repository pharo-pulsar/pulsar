Class {
	#name : 'PulsarEditorTest',
	#superclass : 'PulsarBaseViewTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'testing' }
PulsarEditorTest class >> isAbstract [

	^ super isAbstract or: [ self = PulsarEditorTest ]
]
