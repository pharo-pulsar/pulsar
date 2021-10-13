Class {
	#name : #StBrowserMethodTemplateEditorPresenter,
	#superclass : #StBrowserMethodEditorPresenter,
	#category : #'NewTools-Browser-View'
}

{ #category : #testing }
StBrowserMethodTemplateEditorPresenter >> isMethodEditor [

	^ false
]

{ #category : #accessing }
StBrowserMethodTemplateEditorPresenter >> tabPriority [

	^ 200
]

{ #category : #accessing }
StBrowserMethodTemplateEditorPresenter >> toolbarActionKinds [
	
	^ { StBrowserEditorCommand }
]

{ #category : #initialization }
StBrowserMethodTemplateEditorPresenter >> updatePresenter [

	codePresenter 
		beForBehavior: self model methodClass;
		text: self model sourceCode
]
