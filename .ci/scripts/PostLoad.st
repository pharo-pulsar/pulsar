"Initialize enumerations"
(Smalltalk classNamed: #GEnumeration) allSubclassesDo: #initializeEnumeration.

"Mark all installed repositories as 'system' (because people do not need to see them)"
IceRepository registry 
	reject: [ :each | each project tags includes: #system ]
	thenDo: [ :each | each project addTag: #system ].

"We want to work with string interpolation, but for now do not install it as it 
 creates problems while saving changes (they become corrupt, digging why). 
 Also current implementation is not backward compatible so we need to think how to  
 do it right."
"(Smalltalk classNamed: #StringInterpolationPlugin) install."

"we ban this rule because is annoying since we use LF as end line (in linux). Also this should be agnostic, we should not care about it."
ReMethodSourceContainsLinefeedsRule enabled: false.
"And this one, since there is no real need of this and is also annoying :P"
ReCompactSourceCodeRule enabled: false.

"Reset iceberg"
'Resetting iceberg...' crTrace.
IceCredentialsProvider useCustomSsh: false.
IceCredentialsProvider sshCredentials
	publicKey: nil;
	privateKey: nil.
IceRepository registry do:[ :each | each location: nil ].

"cleaning agressively as a last step to ensure image will go down."
Smalltalk cleanUp: true.


"Force platform reset for the case where we run on linux (as we are building in linux, this is healthy)"
FFIStructure resetLastCompilationPlatform.
LGitExternalStructure allSubclassesDo: #resetCompiledSpec.
