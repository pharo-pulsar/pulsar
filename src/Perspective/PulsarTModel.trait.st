"
A base for all the models of the browser.
Is important that all models uses this trait to allow models to move on the system without having major problems.

Important methods: 
- `accept:` -> this will make your model part of the visit system. By default it just call `visitModel:`, override it as needed.
 
"
Trait {
	#name : 'PulsarTModel',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'visiting' }
PulsarTModel >> accept: aVisitor [

	^ aVisitor visitModel: self
]

{ #category : 'accessing' }
PulsarTModel >> activationAnnouncementClass [

	^ PulsarModelActivated
]

{ #category : 'testing' }
PulsarTModel >> canBeActivated [

	^ self activationAnnouncementClass isNotNil
]

{ #category : 'accessing' }
PulsarTModel >> fullName [

	^ self name
]

{ #category : 'accessing' }
PulsarTModel >> iconName [

	^ self shouldBeImplemented
]

{ #category : 'accessing' }
PulsarTModel >> name [

	^ self shouldBeImplemented
]

{ #category : 'instance creation' }
PulsarTModel >> newActivationAnnouncement [

	^ self activationAnnouncementClass newValue: self
]

{ #category : 'instance creation' }
PulsarTModel >> newSelectionAnnouncement [

	^ self selectionAnnouncementClass newValue: self
]

{ #category : 'accessing' }
PulsarTModel >> selectionAnnouncementClass [

	^ PulsarModelSelected
]
