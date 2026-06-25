Trait {
	#name : 'PulsarTPopover',
	#category : 'Pulsar-Browser-Base',
	#package : 'Pulsar-Browser',
	#tag : 'Base'
}

{ #category : 'initialization' }
PulsarTPopover >> addPopoverControls [

	self shouldBeImplemented
]

{ #category : 'private' }
PulsarTPopover >> detachWindowWith: aModel [
	| newBrowser |

	newBrowser := PulsarDetachedBrowser 
		newApplication: self application 
		model: self window model.
	
	"it seems to look better if I open it first (the visualisation effect is nicer)"
	newBrowser open.
	
	newBrowser notificationCenter announce: aModel newActivationAnnouncement
]

{ #category : 'private - factory' }
PulsarTPopover >> newPopoverControlBoxPresenter [
	| controlsPresenter |

	controlsPresenter := self instantiate: PulsarPopoverControlBoxPresenter.
	controlsPresenter 
		onAttach: [ 
			self withPopoverDo: #dismiss.
			self notifyActivateEntity: self model ];
		onDetach: [
			self withPopoverDo: #dismiss.
			self detachWindowWith: self model ].

	^ controlsPresenter
]
