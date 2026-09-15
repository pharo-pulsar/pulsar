Class {
	#name : 'PulsarProjectViewTest',
	#superclass : 'PulsarBaseViewTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'accessing' }
PulsarProjectViewTest >> classToTest [

	^ PulsarProjectView
]

{ #category : 'running' }
PulsarProjectViewTest >> tearDown [

	self ensureRemoveClass: self mockClassName.
	super tearDown
]

{ #category : 'tests' }
PulsarProjectViewTest >> testActivatedClassEditorInProjectIsSelected [
	"tests when activating a class in an editor, and the class is inside an opened 
	 project, the class is selected"

	self addClass.
	self openBrowserOnProject.
	browser openClass: self mockClass.
	self waitForUI.
	
	self assert: browser projectView listPresenter selectedItem isNotNil.
	self 
		assert: browser projectView listPresenter selectedItem name
		equals: self mockClassName
]

{ #category : 'tests' }
PulsarProjectViewTest >> testAddProject [
	| items |

	self openBrowser.
	browser projectView addProject: BaselineOfPulsar.
	
	items := browser projectView listPresenter roots.
	
	self assert: (items anySatisfy: [ :each | each entity = BaselineOfPulsar ])
]

{ #category : 'running' }
PulsarProjectViewTest >> testCollapseAllClearsExpandedItems [
	| tree |
	
	self openBrowserOnProject.
	tree := browser projectView listPresenter.
	tree expandPath: #(1 1).
	self waitForUI.
	self assert: browser projectView expandedItems isNotEmpty.
	
	browser projectView doCollapseAll.
	self waitForUI.
	
	self assert: browser projectView expandedItems isEmpty.
]

{ #category : 'running' }
PulsarProjectViewTest >> testCollapsedBranchStaysCollapsed [
	| tree |
	
	self openBrowserOnProject.
	tree := browser projectView listPresenter.
	
	self deny: (tree isExpanded: #(1 1)).
]

{ #category : 'tests' }
PulsarProjectViewTest >> testDoRemoveSelectedEntityWhenProjectModel [
	"tests a new editor for a new class is added when we request it"

	self openBrowserOnProject.
	"go to project"
	browser projectView listPresenter selectPath: #(1).
	self waitForUI.

	self assert: browser projectView model children size equals: 1.
	self assert: browser projectView listPresenter selectedItem class equals: PulsarProjectModel.

	"request"	
	browser projectView doRemoveSelectedEntity.
	self waitForUI.	
	
	self assert: browser projectView model children size equals: 0.
	self assert: browser projectView listPresenter roots size equals: 1 "system environemnt"
]

{ #category : 'tests' }
PulsarProjectViewTest >> testDoRequestNewClass [
	"tests a new editor for a new class is added when we request it"
	| title |

	title := PvNewClassTemplate new name.

	self openBrowserOnProject.
	self assert: (browser presenterWithTitle: title) isNil.
	"go to a package"
	browser projectView listPresenter selectPath: #(1 1).
	"request"
	browser projectView doRequestNewClass.
	self waitForUI.
	self assert: (browser presenterWithTitle: title) isNotNil
]

{ #category : 'running' }
PulsarProjectViewTest >> testExpandedBranchSurvivesRefresh [
	| tree |
	
	self openBrowserOnProject.
	tree := browser projectView listPresenter.
	
	"expand the first package of the project"
	tree expandPath: #(1 1).
	self waitForUI.
	
	"refresh as a model update would"
	browser projectView updatePresenter.
	self waitForUI.
	
	self assert: (tree isExpanded: #(1 1)).
]

{ #category : 'running' }
PulsarProjectViewTest >> testRemovedProjectIsPrunedFromExpandedItems [
	| tree project |
	
	self openBrowserOnProject.
	tree := browser projectView listPresenter.
	tree expandPath: #(1 1).
	self waitForUI.
	self assert: browser projectView expandedItems isNotEmpty.
	
	project := browser projectView model children first.
	browser projectView removeProjectModel: project.
	self waitForUI.
	
	self assert: browser projectView expandedItems isEmpty.
]

{ #category : 'running' }
PulsarProjectViewTest >> testSnapshotRemembersExpandedBranches [
	| tree snapshot projectSnapshot |
	
	self openBrowserOnProject.
	tree := browser projectView listPresenter.
	tree expandPath: #(1 1).
	self waitForUI.
	
	snapshot := browser snapshot.
	projectSnapshot := snapshot snapshotWithClass: PulsarProjectSnapshot.
	
	self assert: projectSnapshot expandedItems asSet equals: browser projectView expandedItems.
]

{ #category : 'running' }
PulsarProjectViewTest >> testSnapshotRestoresExpandedBranches [
	| tree snapshot restoredBrowser restoredView restoredTree |
	
	self openBrowserOnProject.
	tree := browser projectView listPresenter.
	tree expandPath: #(1 1).
	self waitForUI.
	snapshot := browser snapshot.
	restoredBrowser := snapshot instantiateOn: self application.
	[
		snapshot restoreTo: restoredBrowser.
		restoredBrowser open.
		self waitForUI.
		restoredView := (restoredBrowser presenterWithClass: PulsarProjectView) presenter.
		restoredTree := restoredView listPresenter.
		self assert: (restoredTree isExpanded: #(1 1)) ]
		ensure: [ restoredBrowser withWindowDo: [ :aWindow | aWindow close ] ].
]
