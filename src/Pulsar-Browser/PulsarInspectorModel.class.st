Class {
	#name : 'PulsarInspectorModel',
	#superclass : 'StInspectorModel',
	#traits : 'PulsarTModel + PulsarTEditable',
	#classTraits : 'PulsarTModel classTrait + PulsarTEditable classTrait',
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'accessing' }
PulsarInspectorModel >> dockEditorClass [

	^ PulsarInspector
]

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
PulsarInspectorModel >> realModel [

	^ self
]
