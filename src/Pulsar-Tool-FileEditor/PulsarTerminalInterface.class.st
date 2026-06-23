"
This utility class opens a terminal on the path provided.
On linux, it does its best to determine which terminal is active on the active desktop, and if none matches it fallbacks to xterm.

"
Class {
	#name : 'PulsarTerminalInterface',
	#superclass : 'Object',
	#classVars : [
		'Default'
	],
	#category : 'Pulsar-Tool-FileEditor-Utilities',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'Utilities'
}

{ #category : 'instance creation' }
PulsarTerminalInterface class >> default [

	^ Default 
		ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
PulsarTerminalInterface class >> default: aClass [ 
	
	Default := aClass
]

{ #category : 'accessing' }
PulsarTerminalInterface >> linuxShell [
	| desktop |

	desktop := OSEnvironment current at: 'XDG_CURRENT_DESKTOP'.
	desktop = 'GNOME' ifTrue: [ ^ 'kgx' ].
	desktop = 'KDE' ifTrue: [ ^ 'konsole' ].	
	desktop = 'Xfce' ifTrue: [ ^ 'xfce4-terminal' ].	
	desktop = 'MATE' ifTrue: [ ^ 'mate-terminal' ].	
	desktop = 'LXQt' ifTrue: [ ^ 'qterminal' ].		
	
	^ 'xterm'
]

{ #category : 'accessing' }
PulsarTerminalInterface >> openFlatpakTerminalShellCommand: aPath [
	| shell |
	
	shell := self linuxShell.
	^ 'flatpak-spawn --host --directory="{1}" {2}' format: { aPath. shell }
]

{ #category : 'accessing' }
PulsarTerminalInterface >> openLinuxTerminalShellCommand: aPath [

	^ 'cd {1} && exec "{2}"' format: { aPath. self linuxShell }
]

{ #category : 'accessing' }
PulsarTerminalInterface >> openMacTerminalShellCommand: aPath [

	| escaped |
	escaped := aPath fullName copyReplaceAll: ' ' with: '\ '. 
	^ String streamContents: [ : stream |
		stream
			<< 'open -a ';
			<< self preferredMacTerminalProgram;
			space;
			<< escaped;
			<< ' &' ]
]

{ #category : 'accessing' }
PulsarTerminalInterface >> openTerminalOn: aPath [

	(self terminalShellCommand: aPath) 
		ifNotEmpty: [ : shellCmd | LibC system: shellCmd ]
]

{ #category : 'accessing' }
PulsarTerminalInterface >> openWindowsTerminalCommand: aPath [

	^ String streamContents: [ : stream |
		stream
			<< 'start cmd.exe /K "cd /d ';
			<< aPath fullName;
			<< '"' ]
]

{ #category : 'accessing' }
PulsarTerminalInterface >> preferredMacTerminalProgram [

	^ StFileBrowserSettings macTerminalProgram

]

{ #category : 'accessing' }
PulsarTerminalInterface >> terminalShellCommand: aPath [
	"Answer a <String> with the shell command to open a terminal for the receiver's OS"

	OSPlatform current isWindows ifTrue: [ ^ self openWindowsTerminalCommand: aPath ].
	OSPlatform current isMacOS ifTrue: [ ^ self openMacTerminalShellCommand: aPath ].
	OSPlatform current isFlatpak ifTrue: [ ^ self openFlatpakTerminalShellCommand: aPath ]. 
	OSPlatform current isLinux ifTrue: [ ^ self openLinuxTerminalShellCommand: aPath ].

	self inform: 'No terminal for platform implemented'.
	
	^ String empty
]
