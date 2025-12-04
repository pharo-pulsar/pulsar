Class {
	#name : 'DockHierarchyModel',
	#superclass : 'Object',
	#traits : 'DockTEditable + DockTModel',
	#classTraits : 'DockTEditable classTrait + DockTModel classTrait',
	#instVars : [
		'parentModel'
	],
	#category : 'Dock-Browser-View-Editor',
	#package : 'Dock-Browser',
	#tag : 'View-Editor'
}

{ #category : 'instance creation' }
DockHierarchyModel class >> on: aParentModel [

	^ self new 
		parentModel: aParentModel;
		yourself
]

{ #category : 'accessing' }
DockHierarchyModel >> dockEditorClass [

	^ DockHierarchyPresenter
]

{ #category : 'accessing' }
DockHierarchyModel >> fullName [

	^ 'Hierarchy on ', self parentModel fullName
]

{ #category : 'accessing - navigating' }
DockHierarchyModel >> hierarchyTopModel [
	
	^ self parentModel hierarchyTopModel
]

{ #category : 'accessing - ui' }
DockHierarchyModel >> iconComposite [
	
	^ PvCompositeIcon new
		name: #smallHierarchyBrowser;
		yourself
]

{ #category : 'testing' }
DockHierarchyModel >> isLargeHierarchy [
	
	^  self parentModel isLargeHierarchy
]

{ #category : 'accessing' }
DockHierarchyModel >> name [

	^ self fullName
]

{ #category : 'accessing' }
DockHierarchyModel >> parentModel [

	^ parentModel
]

{ #category : 'accessing' }
DockHierarchyModel >> parentModel: aModel [

	parentModel := aModel
]

{ #category : 'accessing' }
DockHierarchyModel >> realModel [
	
	^ self
]
