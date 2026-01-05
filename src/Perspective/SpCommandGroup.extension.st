Extension { #name : 'SpCommandGroup' }

{ #category : '*Perspective' }
SpCommandGroup >> copyWithContext: aContext [
	
	^ self copy 
		entries: (self entries collect: [ :each | each copyWithContext: aContext ]);
		yourself
]

{ #category : '*Perspective' }
SpCommandGroup >> entries: aCollection [

	self decoratedGroup entries: aCollection
]

{ #category : '*Perspective' }
SpCommandGroup >> hasEntries [

	^ self entries isNotEmpty
]

{ #category : '*Perspective' }
SpCommandGroup >> joinWith: anActionGroup [

	self entries: (self entries, anActionGroup entries)
]
