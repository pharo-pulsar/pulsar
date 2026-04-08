Class {
	#name : 'PulsarBrowserEnsureClassOverviewVisitor',
	#superclass : 'PulsarEditorVisitor',
	#category : 'Pulsar-Browser-Tool-Debugger',
	#package : 'Pulsar-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'visiting' }
PulsarBrowserEnsureClassOverviewVisitor >> visitClassEditor: aPresenter [

	self owner ensureClassOutlineOverview
]

{ #category : 'visiting' }
PulsarBrowserEnsureClassOverviewVisitor >> visitMethodEditor: aPresenter [

	self owner ensureClassOutlineOverview
]
