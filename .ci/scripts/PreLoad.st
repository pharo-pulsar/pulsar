"Set use custom keys (it will take the default, which we want)"
IceCredentialsProvider useCustomSsh: true.

"Install MetaMetacello"
Metacello new 
	repository: 'github://estebanlm/MetaMetacello:main';
	baseline: 'MetaMetacello';
	load.