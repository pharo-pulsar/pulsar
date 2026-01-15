Extension { #name : 'IceTipLocalRepositoryPanel' }

{ #category : '*Pulsar-Tool-Repositories' }
IceTipLocalRepositoryPanel >> repositoryCreator [

	^ IceRepositoryCreator new
		repository: repository;
		location: self location;
		yourself
]
