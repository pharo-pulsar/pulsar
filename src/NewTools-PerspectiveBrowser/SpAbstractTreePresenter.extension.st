Extension { #name : #SpAbstractTreePresenter }

{ #category : #'*NewTools-PerspectiveBrowser' }
SpAbstractTreePresenter >> addNavigationShortcuts [

	self
		bindKeyCombination: KeyboardKey space asKeyCombination | KeyboardKey right asKeyCombination
			toAction: [ self expandPath: self selection selectedPath ];
		bindKeyCombination: KeyboardKey left asKeyCombination
			toAction: [ self collapsePath: self selection selectedPath ]
]
