"
A base for all the models of the browser.
Is important that all models uses this trait to allow models to move on the system without having major problems.

Important methods: 
- `accept:` -> this will make your model part of the visit system. By default it just call `visitModel:`, override it as needed.
 
"
Trait {
	#name : 'DockTModel',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'visiting' }
DockTModel >> accept: aVisitor [

	^ aVisitor visitModel: self
]

{ #category : 'accessing' }
DockTModel >> activationAnnouncementClass [

	^ DockModelActivated
]

{ #category : 'instance creation' }
DockTModel >> newActivationAnnouncement [

	^ self activationAnnouncementClass newValue: self
]

{ #category : 'instance creation' }
DockTModel >> newSelectionAnnouncement [

	^ self selectionAnnouncementClass newValue: self
]

{ #category : 'accessing' }
DockTModel >> selectionAnnouncementClass [

	^ DockModelSelected
]
