"
Define editor exclusive methods.
In general, all presenters including this trait should have a model including `PulsarTEditable`
"
Trait {
	#name : 'PulsarTEditor',
	#category : 'Pulsar-Browser-View-Editor',
	#package : 'Pulsar-Browser',
	#tag : 'View-Editor'
}

{ #category : 'definitions' }
PulsarTEditor classSide >> defineWindowActionsOn: aBuilder [
	<dockActions>

	aBuilder addGroup: #panelWidget with: [ :group | group
		priority: 1010;
		name: 'Window';
		beDisplayedAsSubMenu;
		addActionWith: [ :action | action
			name: 'Maximize';
			description: 'Maximize current window';
			action: [ :aContext | aContext withPanelWidgetDo: #maximize ] ];		
		addActionWith: [ :action | action
			name: 'Detach';
			shortcutKey: Character arrowUp alt shift;
			description: 'Detach this window from this browser (open a new window)';
			action: [ :aContext | aContext doDetachWindow ] ] ]
]

{ #category : 'testing' }
PulsarTEditor >> isEditor [

	^ true
]
