Class {
	#name : 'PulsarDebuggerEnsureClassOverviewVisitor',
	#superclass : 'PulsarEditorVisitor',
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'visiting' }
PulsarDebuggerEnsureClassOverviewVisitor >> visitClassEditor: aPresenter [

	self owner ensureClassOutlineOverview
]

{ #category : 'visiting' }
PulsarDebuggerEnsureClassOverviewVisitor >> visitMethodEditor: aPresenter [

	self owner ensureClassOutlineOverview
]
