Class {
	#name : 'PulsarHierarchyModel',
	#superclass : 'Object',
	#traits : 'PulsarTEditable + PulsarTModel',
	#classTraits : 'PulsarTEditable classTrait + PulsarTModel classTrait',
	#instVars : [
		'parentModel'
	],
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'instance creation' }
PulsarHierarchyModel class >> on: aParentModel [

	^ self new 
		parentModel: aParentModel;
		yourself
]

{ #category : 'accessing' }
PulsarHierarchyModel >> fullName [

	^ 'Hierarchy on ', self parentModel fullName
]

{ #category : 'accessing - navigating' }
PulsarHierarchyModel >> hierarchyTopModel [
	
	^ self parentModel hierarchyTopModel
]

{ #category : 'accessing - ui' }
PulsarHierarchyModel >> iconComposite [
	
	^ PvCompositeIcon new
		name: self iconName;
		yourself
]

{ #category : 'accessing - ui' }
PulsarHierarchyModel >> iconName [

	^ #smallHierarchyBrowser
]

{ #category : 'testing' }
PulsarHierarchyModel >> isLargeHierarchy [
	
	^  self parentModel isLargeHierarchy
]

{ #category : 'accessing' }
PulsarHierarchyModel >> name [

	^ self fullName
]

{ #category : 'accessing' }
PulsarHierarchyModel >> parentModel [

	^ parentModel
]

{ #category : 'accessing' }
PulsarHierarchyModel >> parentModel: aModel [

	parentModel := aModel
]

{ #category : 'accessing' }
PulsarHierarchyModel >> pulsarEditorClass [

	^ PulsarHierarchyPresenter
]

{ #category : 'accessing' }
PulsarHierarchyModel >> realModel [
	
	^ self
]
