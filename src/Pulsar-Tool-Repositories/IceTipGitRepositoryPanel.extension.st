Extension { #name : 'IceTipGitRepositoryPanel' }

{ #category : '*Pulsar-Tool-Repositories' }
IceTipGitRepositoryPanel >> repositoryCreator [

	^ IceRepositoryCreator new
		  repository: repository;
		  remote: (IceGitRemote url: self remoteUrl);
		  location: self projectLocation location;
		  yourself
]
