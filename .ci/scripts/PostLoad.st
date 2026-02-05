"Initialize enumerations"
(Smalltalk classNamed: #GEnumeration) allSubclassesDo: #initializeEnumeration.

"We want to work with string interpolation, but for now do not install it as it 
 creates problems while saving changes (they become corrupt, digging why). 
 Also current implementation is not backward compatible so we need to think how to  
 do it right."
"(Smalltalk classNamed: #StringInterpolationPlugin) install."

"we ban this rule because is annoying since we use LF as end line (in linux). Also this should be agnostic, we should not care about it."
ReMethodSourceContainsLinefeedsRule enabled: false.
"And this one, since there is no real need of this and is also annoying :P"
ReCompactSourceCodeRule enabled: false.

IceCredentialsProvider useCustomSsh: false.