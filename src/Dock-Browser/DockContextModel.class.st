Class {
	#name : 'DockContextModel',
	#superclass : 'PvBaseModel',
	#instVars : [
		'name',
		'session'
	],
	#category : 'Dock-Browser-Tool-Debugger',
	#package : 'Dock-Browser',
	#tag : 'Tool-Debugger'
}

{ #category : 'instance creation' }
DockContextModel class >> newEnvironment: anEnvironmentModel session: aDebugSession context: aContext [

	^ (self newEnvironment: anEnvironmentModel entity: aContext)
		session: aDebugSession;
		yourself
]

{ #category : 'accessing' }
DockContextModel >> actionDecorators [

	^ #()
]

{ #category : 'accessing' }
DockContextModel >> context [

	"a synonym for clarity"
	^ self entity
]

{ #category : 'accessing' }
DockContextModel >> fullName [

	^ name
]

{ #category : 'private' }
DockContextModel >> inOneLine [
	"put the context in one line requires some work as e.g. blocks can't be 'just'
	 printed (as they are often not visible)"
	| string |

	string := ((self entity asString
		truncateWithElipsisTo: 200)
		copyReplaceAll: String cr with: ' ')
		copyReplaceAll: String tab with: ' '.

	[ string includesSubstring: '   ' ] 
	whileTrue: [ string := string copyReplaceAll: '   ' with: ' ' ].
	
	^ string
]

{ #category : 'accessing' }
DockContextModel >> method [

	^ self entity method
]

{ #category : 'accessing' }
DockContextModel >> methodClassName [

	^ self entity methodClass name
]

{ #category : 'accessing' }
DockContextModel >> methodName [

	^ self realMethod selector
]

{ #category : 'accessing' }
DockContextModel >> name [

	^ name ifNil: [ name := self inOneLine ]
]

{ #category : 'accessing' }
DockContextModel >> packageName [

	^ self entity methodClass packageName
]

{ #category : 'accessing' }
DockContextModel >> protocolName [

	^  self realMethod protocolName
]

{ #category : 'private' }
DockContextModel >> realMethod [

	^ self method isCompiledBlock
		ifTrue: [ self method method ]
		ifFalse: [ self method ]
]

{ #category : 'accessing' }
DockContextModel >> selectedCodeRange [

	^ self session selectedCodeRangeForContext: self context
]

{ #category : 'private' }
DockContextModel >> session [

	^ session
]

{ #category : 'initialization' }
DockContextModel >> session: aDebugSession [

	session := aDebugSession
]

{ #category : 'accessing' }
DockContextModel >> sourceCode [

	^ self entity sourceCode
]
