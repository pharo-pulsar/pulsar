"
A read-only editor that renders a web page using `WebKitPresenter`.

Unlike the text editors, it does not track dirty state or text changes: it only loads the URL exposed by its `PulsarWebModel`. Every text-editor hook inherited from `PulsarEditor` is overridden so the web view is never asked for text, syntax or cursor information.
"
Class {
	#name : 'PulsarWebEditor',
	#superclass : 'PulsarEditor',
	#traits : 'PulsarTSnapshot',
	#classTraits : 'PulsarTSnapshot classTrait',
	#category : 'Pulsar-Tool-HTML-View',
	#package : 'Pulsar-Tool-HTML',
	#tag : 'View'
}

{ #category : 'initialization' }
PulsarWebEditor >> connectPresenters [
	"The web view is read-only: there are no text changes to react to."

	
]

{ #category : 'initialization' }
PulsarWebEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPresenter expand: false;
		  add: (self editorOverlayLayout
				   child: editorPresenter;
				   yourself);
		  yourself
]

{ #category : 'actions' }
PulsarWebEditor >> defineActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #navigation with: [ :group |
			group
				priority: 100;
				name: 'Actions';
				beDisplayedAsGroup;
				addActionWith: [ :action |
						action
							name: 'Reload';
							iconName: 'refresh';
							description: 'Reload the current page';
							action: [ self updateSource ] ] ]
]

{ #category : 'actions' }
PulsarWebEditor >> defineNavigationActionsOn: aBuilder [

	<dockActions>
	
]

{ #category : 'actions' }
PulsarWebEditor >> doBrowseSendersCommand: aCommand [
	"Not applicable for a web editor."

	
]

{ #category : 'actions' }
PulsarWebEditor >> editorContextMenuActions [

	^ SpActionGroup new
]

{ #category : 'events' }
PulsarWebEditor >> eventModelRemoved: anAnnouncement [

	anAnnouncement value = self model ifFalse: [ ^ self ].
	self withPanelWidgetDo: [ :aPanelWindow | aPanelWindow close ]
]

{ #category : 'events' }
PulsarWebEditor >> eventThemeChanged: anAnnouncement [

	self updatePresentersAfterThemeChange
]

{ #category : 'initialization' }
PulsarWebEditor >> initializeEditor [

	editorPresenter := self instantiate: WebKitPresenter
]

{ #category : 'initialization' }
PulsarWebEditor >> initializePresenters [

	self addStyle: 'pulsarEditor'.
	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter actions: self editorToolbarActions.
	self initializeEditor
]

{ #category : 'initialization' }
PulsarWebEditor >> notificationCenter: anAnnouncer [
	"The web view has no text navigation, so skip the system navigation wiring done by the text editors."

	self basicNotificationCenter: anAnnouncer
]

{ #category : 'accessing' }
PulsarWebEditor >> originalContent [
	"Read-only editor: there is nothing to compare against."

	^ nil
]

{ #category : 'events' }
PulsarWebEditor >> registerToSystemEvents [
	"No Pharo system events to listen to for a web editor."

	
]

{ #category : 'actions' }
PulsarWebEditor >> saveContent [
	"Nothing to save in a read-only web editor."

	^ true
]

{ #category : 'updating' }
PulsarWebEditor >> updateBreadcrumbs [

	toolbarPresenter updateBreadcrumbWith: [ :aBreadcrumb |
			aBreadcrumb
				addSegment: self model fullName;
				addButtonSegment: 'copy-to-clipboard'
				help: ('Copy {1} to the clipboard' format: { self model fullName })
				action: [ self doCopyToClipboard ] ]
]

{ #category : 'updating' }
PulsarWebEditor >> updatePresenter [

	self model ifNil: [ ^ self ].
	self updateSource.
	self updateBreadcrumbs
]

{ #category : 'updating' }
PulsarWebEditor >> updateSource [

	editorPresenter loadUri: self model entity asString
]
