Class {
	#name : 'DockInspectorModel',
	#superclass : 'StInspectorModel',
	#traits : 'DockTEditor',
	#classTraits : 'DockTEditor classTrait',
	#category : 'Dock-Browser-Tool-Inspector',
	#package : 'Dock-Browser',
	#tag : 'Tool-Inspector'
}

{ #category : 'accessing' }
DockInspectorModel >> dockEditorClass [

	^ DockRawInspectionPresenter
]

{ #category : 'accessing' }
DockInspectorModel >> fullName [

	^ self windowTitle
]

{ #category : 'accessing' }
DockInspectorModel >> iconComposite [
	
	^ PvCompositeIcon new 
		name: self iconName;
		yourself
]

{ #category : 'accessing' }
DockInspectorModel >> iconName [

	^ #inspector
]

{ #category : 'accessing' }
DockInspectorModel >> realModel [

	^ self
]
