Class {
	#name : #PvToggleLineNumbersAction,
	#superclass : #PvAction,
	#traits : 'PvTToggeableAction',
	#classTraits : 'PvTToggeableAction classTrait',
	#category : #'Perspective-View-Editor'
}

{ #category : #accessing }
PvToggleLineNumbersAction >> context: aContext [

	super context: aContext.
	self state: aContext isShowingLineNumbers
]

{ #category : #initialization }
PvToggleLineNumbersAction >> defineAction [

	self name: 'Line numbers'.
	self description: 'Toggle line numbers.'.
	self iconCompositeName: 'line-numbers'
]

{ #category : #executing }
PvToggleLineNumbersAction >> execute [
	
	self toggleState.
	context showLineNumbers: self state
]

{ #category : #'as yet unclassified' }
PvToggleLineNumbersAction >> initialize [
	
	super initialize.
	state := false
]
