Class {
	#name : #StBrowserEditorContainerPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'window'
	],
	#category : #'NewTools-Browser-Tests'
}

{ #category : #tests }
StBrowserEditorContainerPresenterTest >> testRemoveEditorUnsubscribeContainer [
	| model editor container dirtyValueHolder |

	model := StMethodModel newMethod: self class>>#testRemoveEditorUnsubscribeContainer.
	editor := StBrowserMethodEditorPresenter on: model.
	container := StBrowserEditorContainerPresenter new.
	
	container basicPushEditor: editor.
	
	dirtyValueHolder := editor observablePropertyNamed: #dirty.

	self assert: (dirtyValueHolder subscriptions 
		anySatisfy: [ :eachBlock | eachBlock outerContext receiver = container]).
		
	container removeEditorsMatching: [ :each | each = editor ].
	
	self deny: (dirtyValueHolder subscriptions 
		anySatisfy: [ :eachBlock | eachBlock outerContext receiver = container]).
	
]
