Extension { #name : 'IceTipNewRepositoryPanel' }

{ #category : '*Pulsar-Tool-Repositories' }
IceTipNewRepositoryPanel >> repositoryCreator [
	| repositoryName location subdirectory |
	
	repositoryName := self projectNameInputText text trimBoth.
	location := self projectLocation location.
	subdirectory := self subdirectoryInputText text asString trimBoth.
	^ PulsarNewRepositoryCreator new
		repository: repository;
		location: location;
		subdirectory: subdirectory;
		requestName: repositoryName;
		yourself
]
