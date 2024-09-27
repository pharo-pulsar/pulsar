Extension { #name : 'SpAbstractEasyTreeListViewPresenter' }

{ #category : '*Perspective' }
SpAbstractEasyTreeListViewPresenter >> addNavigationShortcuts [

	self flag: #TODO.
	"self
		bindKeyCombination: KeyboardKey space asKeyCombination | KeyboardKey right asKeyCombination
			toAction: [ self expandPath: self selection selectedPath ];
		bindKeyCombination: KeyboardKey left asKeyCombination
			toAction: [ self collapsePath: self selection selectedPath ]"
]
