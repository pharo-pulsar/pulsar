Class {
	#name : 'PvMethodModelTest',
	#superclass : 'PvBaseModelTest',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
PvMethodModelTest >> testHierarchyTopModelForClassSide [
	| model topModel |

	model := PvMethodModel 
		newEnvironment: nil
		entity: Collection class>>#newFromArray:.
	
	topModel := model hierarchyTopModel.
	
	self assert: topModel entity equals: Object class>>#newFromArray:.
	self denyEmpty: topModel children.
	self assert: topModel children first entity equals: Collection class>>#newFromArray:
]
