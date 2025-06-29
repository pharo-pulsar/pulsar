Class {
	#name : 'DockPlaygroundVersionsBrowser',
	#superclass : 'DockVersionsBrowser',
	#category : 'Dock-Browser-Tool-Playground',
	#package : 'Dock-Browser',
	#tag : 'Tool-Playground'
}

{ #category : 'initialization' }
DockPlaygroundVersionsBrowser >> updateSourceCodeWith: aDefinition [
		
	sourcePresenter 
		beForScripting;
		text: aDefinition sourceCode
]
