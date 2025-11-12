Class {
	#name : 'DockProjectViewTest',
	#superclass : 'DockBaseViewTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'accessing' }
DockProjectViewTest >> classToTest [

	^ DockProjectView
]

{ #category : 'running' }
DockProjectViewTest >> tearDown [

	self ensureRemoveClass: self mockClassName.
	super tearDown
]

{ #category : 'tests' }
DockProjectViewTest >> testActivatedClassEditorInProjectIsSelected [
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
DockProjectViewTest >> testAddProject [
	| items |

	self openBrowser.
	browser projectView addProject: BaselineOfPerspective.
	
	items := browser projectView listPresenter roots.
	
	self assert: (items anySatisfy: [ :each | each entity = BaselineOfPerspective ])
]

{ #category : 'tests' }
DockProjectViewTest >> testDoRemoveSelectedEntityWhenProjectModel [
	"tests a new editor for a new class is added when we request it"

	self openBrowserOnProject.
	"go to project"
	browser projectView listPresenter selectPath: #(1).
	self waitForUI.

	self assert: browser projectView model children size equals: 1.
	self assert: browser projectView listPresenter selectedItem class equals: DockProjectModel.

	"request"	
	browser projectView doRemoveSelectedEntity.
	self waitForUI.	
	
	self assert: browser projectView model children size equals: 0.
	self assert: browser projectView listPresenter roots size equals: 1 "system environemnt"
]

{ #category : 'tests' }
DockProjectViewTest >> testDoRequestNewClass [
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
