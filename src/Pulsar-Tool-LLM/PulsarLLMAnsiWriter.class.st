"
I build ANSI SGR escape sequences (256-color and true-color) as plain Strings.

Use me to colorize text fed to an ANSI-capable terminal such as the VTE widget used by Pulsar. I am stateless: every method answers a String that can be concatenated with content.
"
Class {
	#name : 'PulsarLLMAnsiWriter',
	#superclass : 'Object',
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'colors' }
PulsarLLMAnsiWriter >> background: anIndex [

	^ self escape , '[48;5;' , anIndex asString , 'm'
]

{ #category : 'styles' }
PulsarLLMAnsiWriter >> bold [

	^ self escape , '[1m'
]

{ #category : 'colors' }
PulsarLLMAnsiWriter >> color: anIndex [

	^ self escape , '[38;5;' , anIndex asString , 'm'
]

{ #category : 'cursor' }
PulsarLLMAnsiWriter >> cursorHome [
	"Answer the sequence that moves the cursor to the first column, without a line feed."

	^ self escape , '[1G'
]

{ #category : 'styles' }
PulsarLLMAnsiWriter >> dim [

	^ self escape , '[2m'
]

{ #category : 'private' }
PulsarLLMAnsiWriter >> escape [

	^ String with: Character escape
]

{ #category : 'styles' }
PulsarLLMAnsiWriter >> italic [

	^ self escape , '[3m'
]

{ #category : 'styles' }
PulsarLLMAnsiWriter >> reset [

	^ self escape , '[0m'
]

{ #category : 'styles' }
PulsarLLMAnsiWriter >> strike [

	^ self escape , '[9m'
]

{ #category : 'styles' }
PulsarLLMAnsiWriter >> strikeOff [

	^ self escape , '[29m'
]

{ #category : 'colors' }
PulsarLLMAnsiWriter >> trueColor: aRed green: aGreen blue: aBlue [

	^ self escape , '[38;2;' , aRed asString , ';' , aGreen asString , ';' , aBlue asString , 'm'
]

{ #category : 'colors' }
PulsarLLMAnsiWriter >> trueColorBackground: aRed green: aGreen blue: aBlue [

	^ self escape , '[48;2;' , aRed asString , ';' , aGreen asString , ';' , aBlue asString , 'm'
]

{ #category : 'styles' }
PulsarLLMAnsiWriter >> underline [

	^ self escape , '[4m'
]
