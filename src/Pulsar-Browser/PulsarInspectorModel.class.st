Class {
	#name : 'PulsarInspectorModel',
	#superclass : 'StInspectorModel',
	#traits : 'PulsarTModel + PulsarTModelEditable + PulsarTModelSnapshot',
	#classTraits : 'PulsarTModel classTrait + PulsarTModelEditable classTrait + PulsarTModelSnapshot classTrait',
	#category : 'Pulsar-Browser-Tool-Inspector',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'converting' }
PulsarInspectorModel >> asPulsarInspectorModel [

	^ self
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
PulsarInspectorModel >> name [

	^ [ self inspectedObject displayString truncateWithElipsisTo: self class maxTitleLength ]
		on: Exception
		do: [ :e | e printString ]
]

{ #category : 'accessing' }
PulsarInspectorModel >> pulsarEditorClass [

	^ PulsarMillerColumnInspector
]

{ #category : 'accessing' }
PulsarInspectorModel >> realModel [

	^ self
]

{ #category : 'accessing' }
PulsarInspectorModel >> windowTitle [

	^ f'Inspector on [self name]'
]
