"
Tests that PulsarSingleProjectView keeps the branches of the tree the user expanded across model refreshes and browser snapshots.
"
Class {
	#name : 'PulsarSingleProjectViewTest',
	#superclass : 'PulsarBaseViewTest',
	#instVars : [
		'view'
	],
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'running' }
PulsarSingleProjectViewTest >> classToTest [

	^ PulsarSingleProjectView
]

{ #category : 'as yet unclassified' }
PulsarSingleProjectViewTest >> openSingleProjectViewOnProject [
	"Open a browser with a PulsarSingleProjectView panel showing the given project."
	| projectModel |
	
	browser := self newBrowser.
	projectModel := PulsarProjectModel
		newEnvironment: (PvEnvironmentModel onSystem)
		entity: BaselineOfPulsar.
	view := self application
		instantiate: PulsarSingleProjectView
		on: projectModel.
	browser addPresenter: view at: (SpPanelPosition startArea row: 2).
	browser open.
	^ view
]

{ #category : 'running' }
PulsarSingleProjectViewTest >> testCollapseAllClearsExpandedItems [
	| tree |
	
	self openSingleProjectViewOnProject.
	tree := view listPresenter.
	tree expandPath: #(1).
	self waitForUI.
	self assert: view expandedItems isNotEmpty.
	
	view doCollapseAll.
	self waitForUI.
	
	self assert: view expandedItems isEmpty
]

{ #category : 'running' }
PulsarSingleProjectViewTest >> testExpandedBranchSurvivesRefresh [
	| tree |
	
	self openSingleProjectViewOnProject.
	tree := view listPresenter.
	
	"expand the first package of the project"
	tree expandPath: #(1).
	self waitForUI.
	
	"refresh as a model update would"
	view updatePresenter.
	self waitForUI.
	
	self assert: (tree isExpanded: #(1))
]

{ #category : 'running' }
PulsarSingleProjectViewTest >> testSnapshotRemembersExpandedBranches [
	| tree snapshot projectSnapshot |
	
	self openSingleProjectViewOnProject.
	tree := view listPresenter.
	tree expandPath: #(1).
	self waitForUI.
	
	snapshot := browser snapshot.
	projectSnapshot := snapshot snapshots
		detect: [ :each | each presenterClass = PulsarSingleProjectView ].
	
	self assert: projectSnapshot expandedItems asSet equals: view expandedItems
]

{ #category : 'running' }
PulsarSingleProjectViewTest >> testSnapshotRestoresExpandedBranches [
	| tree snapshot restoredBrowser restoredView restoredTree |
	
	self openSingleProjectViewOnProject.
	tree := view listPresenter.
	tree expandPath: #(1).
	self waitForUI.
	snapshot := browser snapshot.
	restoredBrowser := snapshot instantiateOn: self application.
	[
		snapshot restoreTo: restoredBrowser.
		restoredBrowser open.
		self waitForUI.
		restoredView := (restoredBrowser presenterWithClass: PulsarSingleProjectView) presenter.
		restoredTree := restoredView listPresenter.
		self assert: (restoredTree isExpanded: #(1)) ]
		ensure: [ restoredBrowser withWindowDo: [ :aWindow | aWindow close ] ]
]
