Extension { #name : 'SpAbstractTreePresenter' }

{ #category : '*Perspective' }
SpAbstractTreePresenter >> addNavigationShortcuts [

	"self ensureInternalActions
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey right asKeyCombination | KeyboardKey space asKeyCombination;
			action: [ self expandPath: self selection selectedPath ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey left asKeyCombination;
			action: [ self collapsePath: self selection selectedPath ] ]"
]
