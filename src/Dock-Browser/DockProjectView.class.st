Class {
	#name : 'DockProjectView',
	#superclass : 'DockCollectionView',
	#instVars : [
		'toolbarPresenter'
	],
	#category : 'Dock-Browser-Core',
	#package : 'Dock-Browser',
	#tag : 'Core'
}

{ #category : 'defaults' }
DockProjectView class >> defaultDockPosition [

	^ DockPosition new 
		area: DockArea start;
		row: 1;
		yourself
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionGroupAction: actionGroup [
	<perspectiveActionGroup: #action>
	
	actionGroup 
		name: 'Action';
		priority: 30;
		beDisplayedAsGroup
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionGroupNew: actionGroup [
	<perspectiveActionGroup: #actionNew>
	
	actionGroup 
		name: 'New';
		priority: 20;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionGroupProject: actionGroup [
	<perspectiveActionGroup: #project>
	
	actionGroup 
		name: 'Project';
		priority: 10;
		beDisplayedAsSubMenu
]

{ #category : 'accessing - actions' }
DockProjectView class >> defineActionsOn: aBuilder [
	<perspectiveActions>
	
	aBuilder 
		registerGroup: #project with: { 
			$n	mod1 	->	PvNewProjectCommand new.
			$o mod1  -> PvOpenProjectCommand new.
							PvRefreshProjectCommand new.
		};
		registerGroup: #actionNew with: { 
			PvNewPackageCommand new.
			PvNewPackageTagCommand new.
			PvNewClassCommand new.
			PvNewTraitCommand new
		};
		registerGroup: #action with: { 
			$r mod1 -> PvRenamePackageCommand new.
			$x mod1 -> PvRemovePackageCommand new.
		}
]

{ #category : 'actions' }
DockProjectView >> addProject: aBaselineClass [
	
	self model addProject: aBaselineClass.
	self updatePresenter.
	listPresenter selectPath: { self model children size }
]

{ #category : 'api - focus' }
DockProjectView >> defaultKeyboardFocus [

	^ listPresenter
]

{ #category : 'layout' }
DockProjectView >> defaultLayout [

	^ SpBoxLayout newVertical
		add: toolbarPresenter expand: false;
		add: listPresenter;
		yourself
]

{ #category : 'initialization' }
DockProjectView >> initializePresenters [

	toolbarPresenter := self newDockToolbar 
		fillWith: (self actions actionsFor: #project);
		yourself.

	listPresenter := self newEntityTree.
	listPresenter addStyle: 'dockProjectTree'
]

{ #category : 'initialization' }
DockProjectView >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: 'Project'	
]

{ #category : 'private' }
DockProjectView >> toolbarPresenter [

	^ toolbarPresenter
]

{ #category : 'initialization' }
DockProjectView >> updatePresenter [

	self model ifNil: [ 
		listPresenter roots: #().
		^ self ].
	
	listPresenter 
		roots: (self model children copyWith: self model environmentModel);
		expandPath: #(1)
]
