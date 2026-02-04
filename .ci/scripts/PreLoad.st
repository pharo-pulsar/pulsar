"Set use custom keys"
IceCredentialsProvider useCustomSsh: true.
IceCredentialsProvider sshCredentials
	publicKey: '/root/.ssh/id_ed25519.pub';
	privateKey: '/root/.ssh/id_ed25519'.

"Install MetaMetacello"
Metacello new 
	repository: 'github://estebanlm/MetaMetacello:main';
	baseline: 'MetaMetacello';
	load.