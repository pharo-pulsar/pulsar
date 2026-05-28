Class {
	#name : 'PulsarRepositoryBaseModelTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests-Model',
	#package : 'Pulsar-Browser-Tests',
	#tag : 'Model'
}

{ #category : 'tests - actions' }
PulsarRepositoryBaseModelTest >> testActionsNotEmpty [
	| model |

	model := PulsarRepositoryCommitModel new.
	self assert: model actions isNotNil
]

{ #category : 'tests - predicates' }
PulsarRepositoryBaseModelTest >> testCanBeActivated [
	| model |

	model := PulsarRepositoryCommitModel new.
	self assert: model canBeActivated
]

{ #category : 'tests - accessing' }
PulsarRepositoryBaseModelTest >> testEntityAccessors [
	| model |

	model := PulsarRepositoryCommitModel new.

	self assert: model entity isNil.

	model entity: #testEntity.
	self assert: model entity equals: #testEntity
]

{ #category : 'tests - accessing' }
PulsarRepositoryBaseModelTest >> testFullName [
	| model |

	model := PulsarRepositoryCommitModel new. "fullName delegates to name, but name raises shouldBeImplemented unless overridden"
	self should: [ model fullName ] raise: Error
]

{ #category : 'tests - creation' }
PulsarRepositoryBaseModelTest >> testNewRepositoryEntity [
	| model |

	model := PulsarRepositoryCommitModel newRepository: nil entity: #testEntity.

	self assert: model repository isNil.
	self assert: model entity equals: #testEntity
]

{ #category : 'tests - snapshot' }
PulsarRepositoryBaseModelTest >> testPrepareForSnapshotDoesNotFail [
	| model |

	model := PulsarRepositoryCommitModel new.
	model prepareForSnapshot "should not raise an error"
]

{ #category : 'tests - accessing' }
PulsarRepositoryBaseModelTest >> testRepositoryAccessors [
	| model |

	model := PulsarRepositoryCommitModel new.

	self assert: model repository isNil.

	model repository: #fakeRepository.
	self assert: model repository equals: #fakeRepository
]
