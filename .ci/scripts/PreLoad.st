"Set use custom keys"
[ 
	| home |

	home := OSEnvironment current at: 'HOME'.

	Stdio stdout << ((home asFileReference / '.ssh') entries asStringWithCr); lf; flush. 

	IceCredentialsProvider useCustomSsh: true.
	IceCredentialsProvider sshCredentials
		publicKey: (home, '/.ssh/id_ed25519.pub');
		privateKey: (home, '/.ssh/id_ed25519').

	
] value.

"Install MetaMetacello"
Metacello new 
	repository: 'github://estebanlm/MetaMetacello:main';
	baseline: 'MetaMetacello';
	load.
