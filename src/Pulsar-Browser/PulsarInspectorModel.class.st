Class {
	#name : 'PulsarInspectorModel',
	#superclass : 'StInspectorModel',
	#traits : 'PulsarTModel + PulsarTEditable + PulsarTModelSnapshot',
	#classTraits : 'PulsarTModel classTrait + PulsarTEditable classTrait + PulsarTModelSnapshot classTrait',
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'accessing' }
PulsarInspectorModel >> fullName [

	^ self windowTitle
]

{ #category : 'accessing' }
PulsarInspectorModel >> iconComposite [
	
	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : 'accessing' }
PulsarInspectorModel >> iconName [

	^ #inspector
]

{ #category : 'accessing' }
PulsarInspectorModel >> pulsarEditorClass [

	^ PulsarInspector
]

{ #category : 'accessing' }
PulsarInspectorModel >> realModel [

	^ self
]
