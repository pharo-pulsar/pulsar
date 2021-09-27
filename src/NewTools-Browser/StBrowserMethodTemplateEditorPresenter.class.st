Class {
	#name : #StBrowserMethodTemplateEditorPresenter,
	#superclass : #StBrowserMethodEditorPresenter,
	#category : #'NewTools-Browser-View'
}

{ #category : #initialization }
StBrowserMethodTemplateEditorPresenter >> updatePresenter [

	codePresenter 
		beForBehavior: self model methodClass;
		text: self model sourceCode
]
