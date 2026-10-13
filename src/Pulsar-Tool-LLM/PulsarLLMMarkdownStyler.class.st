"
I turn markdown text into ANSI-styled text for the Pulsar terminal.

I am used incrementally: each call to #format: styles one chunk and remembers whether it ended inside a fenced code block or at a line start, so multi-chunk answers keep their structure. I support fenced code blocks, inline code, bold, italic, links, headings and bullets.
"
Class {
	#name : 'PulsarLLMMarkdownStyler',
	#superclass : 'Object',
	#instVars : [
		'ansi',
		'palette',
		'inFencedCode',
		'atLineStart',
		'pendingTail',
		'inFenceHeader'
	],
	#category : 'Pulsar-Tool-LLM-Agent',
	#package : 'Pulsar-Tool-LLM',
	#tag : 'Agent'
}

{ #category : 'accessing' }
PulsarLLMMarkdownStyler >> ansi [

	^ ansi
]

{ #category : 'accessing' }
PulsarLLMMarkdownStyler >> ansi: anObject [

	ansi := anObject
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> bulletStyle: aLine [

	^ (ansi color: (self colorAt: #bullet)) , aLine , ansi reset
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> codeStyle: aLine [

	^ (ansi color: (self colorAt: #code)) , (ansi background: (self colorAt: #codeBackground)) , aLine , ansi reset
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> colorAt: aSymbol [

	^ palette at: aSymbol ifAbsent: [ 252 ]
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> escapeTokenIn: aLine from: anIndex [

	anIndex = aLine size ifTrue: [ ^ Array with: '\' with: anIndex + 1 ].
	^ Array with: (aLine at: anIndex + 1) asString with: anIndex + 2
]

{ #category : 'formatting' }
PulsarLLMMarkdownStyler >> format: aString [
	"Style aString, remembering fenced-code, line-start and pending inline state."

	| out input line |
	out := WriteStream on: String new.
	input := pendingTail , aString.
	pendingTail := ''.
	line := WriteStream on: String new.
	input do: [ :eachCharacter |
			| isNewline |
			isNewline := eachCharacter = Character lf or: [ eachCharacter = Character cr ].
			inFenceHeader
				ifTrue: [
						isNewline ifTrue: [
								inFenceHeader := false.
								atLineStart := true ] ]
				ifFalse: [
						isNewline
							ifTrue: [
									| styled |
									styled := self formatLine: line contents lineStart: atLineStart.
									styled ifNotNil: [
											out nextPutAll: styled.
											out nextPut: eachCharacter ].
									line := WriteStream on: String new.
									atLineStart := true ]
							ifFalse: [ line nextPut: eachCharacter ] ] ].
	line contents ifNotEmpty: [
			| styled |
			styled := self formatTrailingLine: line contents.
			styled ifNotNil: [ out nextPutAll: styled ] ].
	^ out contents
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> formatLine: aLine lineStart: aBoolean [
	"Answer the styled line, or nil to suppress both the line and its newline."

	| trimmed |
	trimmed := aLine trimBoth.
	inFencedCode ifTrue: [
			(trimmed beginsWith: '```') ifTrue: [
					inFencedCode := false.
					^ nil ].
			^ self codeStyle: aLine ].
	(aBoolean and: [ trimmed beginsWith: '```' ]) ifTrue: [
			inFencedCode := true.
			^ nil ].
	(aBoolean and: [ trimmed beginsWith: '>' ]) ifTrue: [ ^ self quoteStyle: aLine ].
	(aBoolean and: [ self isHorizontalRule: trimmed ]) ifTrue: [ ^ self ruleStyle ].
	(aBoolean and: [ trimmed beginsWith: '#' ]) ifTrue: [ ^ self headingStyle: aLine ].
	(aBoolean and: [ self isListLine: trimmed ]) ifTrue: [ ^ self listLine: aLine ].
	^ self inlineStyle: aLine
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> formatTrailingLine: aLine [
	"Style a partial line, holding back an unterminated inline tail or an incomplete block marker."

	| parts trimmed lineStart |
	trimmed := aLine trimBoth.
	lineStart := atLineStart.
	(inFencedCode or: [ trimmed beginsWith: '```' ]) ifTrue: [
			(inFencedCode not and: [ trimmed beginsWith: '```' ]) ifTrue: [ inFenceHeader := true ].
			atLineStart := false.
			^ self formatLine: aLine lineStart: lineStart ].
	(lineStart and: [ self isPotentialMarkerPrefix: aLine ]) ifTrue: [
			pendingTail := aLine.
			^ '' ].
	parts := self splitInlineTail: aLine.
	atLineStart := false.
	pendingTail := parts second.
	parts first ifEmpty: [ ^ '' ].
	^ self formatLine: parts first lineStart: lineStart
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> headingStyle: aLine [

	^ ansi bold , (ansi color: (self colorAt: #heading)) , (self inlineStyle: (self headingText: aLine)) , ansi reset
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> headingText: aLine [

	| trimmed index |
	trimmed := aLine trimBoth.
	index := trimmed findFirst: [ :each | each ~= $# ].
	index = 0 ifTrue: [ ^ '' ].
	^ (trimmed copyFrom: index to: trimmed size) trimBoth
]

{ #category : 'initialize' }
PulsarLLMMarkdownStyler >> initialize [

	ansi := PulsarLLMAnsiWriter new.
	palette := Dictionary new.
	inFencedCode := false.
	inFenceHeader := false.
	atLineStart := true.
	pendingTail := ''.
	super initialize
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> inlineStyle: aLine [

	| out index size |
	out := WriteStream on: String new.
	index := 1.
	size := aLine size.
	[ index <= size ] whileTrue: [
			| token |
			token := self nextInlineTokenIn: aLine from: index.
			out nextPutAll: token first.
			index := token second ].
	^ out contents
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> isBullet: aTrimmedLine [

	^ (aTrimmedLine beginsWith: '- ') or: [ (aTrimmedLine beginsWith: '* ') or: [ aTrimmedLine beginsWith: '+ ' ] ]
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> isHorizontalRule: aTrimmedLine [

	| characters |
	characters := aTrimmedLine reject: [ :each | each = Character space ].
	characters size < 3 ifTrue: [ ^ false ].
	(characters allSatisfy: [ :each | each = $- ]) ifTrue: [ ^ true ].
	(characters allSatisfy: [ :each | each = $* ]) ifTrue: [ ^ true ].
	^ characters allSatisfy: [ :each | each = $_ ]
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> isListLine: aTrimmedLine [

	^ (self isBullet: aTrimmedLine) or: [ self isOrderedItem: aTrimmedLine ]
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> isOrderedItem: aTrimmedLine [

	| index |
	index := 1.
	[ index <= aTrimmedLine size and: [ (aTrimmedLine at: index) isDigit ] ] whileTrue: [ index := index + 1 ].
	index = 1 ifTrue: [ ^ false ].
	index < aTrimmedLine size ifFalse: [ ^ false ].
	((aTrimmedLine at: index) = $. or: [ (aTrimmedLine at: index) = $) ]) ifFalse: [ ^ false ].
	^ (aTrimmedLine at: index + 1) = Character space
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> isPotentialMarkerPrefix: aLine [
	"Answer whether aLine could be the beginning of a block marker (#, >, -, *, +, ordered)."

	| trimmed |
	trimmed := aLine trimBoth.
	trimmed isEmpty ifTrue: [ ^ false ].
	trimmed size > 8 ifTrue: [ ^ false ].
	^ trimmed allSatisfy: [ :each |
			  each = $# or: [
					  each = $- or: [
							  each = $* or: [
									  each = $> or: [
										  each = $_ or: [ each = $+ or: [ each isDigit or: [ each = $. or: [ each = $) or: [ each = Character space ] ] ] ] ] ] ] ] ] ]
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> lastUnmatched: aDelimiter in: aLine [

	| index count last |
	index := 1.
	count := 0.
	last := 0.
	[ index <= aLine size ] whileTrue: [
			| found |
			found := aLine indexOfSubCollection: aDelimiter startingAt: index.
			found = 0
				ifTrue: [ index := aLine size + 1 ]
				ifFalse: [
						count := count + 1.
						last := found.
						index := found + aDelimiter size ] ].
	^ count odd
		  ifTrue: [ last ]
		  ifFalse: [ nil ]
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> linkTokenIn: aLine from: anIndex [

	| closeBracket closeParenthesis text |
	closeBracket := aLine indexOf: $] startingAt: anIndex + 1.
	closeBracket = 0 ifTrue: [ ^ Array with: '[' with: anIndex + 1 ].
	(aLine at: closeBracket + 1 ifAbsent: [ nil ]) = $( ifFalse: [ ^ Array with: '[' with: anIndex + 1 ].
	closeParenthesis := aLine indexOf: $) startingAt: closeBracket + 2.
	closeParenthesis = 0 ifTrue: [ ^ Array with: '[' with: anIndex + 1 ].
	text := aLine copyFrom: anIndex + 1 to: closeBracket - 1.
	^ Array with: ansi underline , (ansi color: (self colorAt: #link)) , text , ansi reset with: closeParenthesis + 1
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> listLine: aLine [

	| firstIndex indent trimmed markerEnd |
	firstIndex := aLine findFirst: [ :each | each ~= Character space and: [ each ~= Character tab ] ].
	firstIndex = 0 ifTrue: [ ^ self inlineStyle: aLine ].
	indent := aLine copyFrom: 1 to: firstIndex - 1.
	trimmed := aLine copyFrom: firstIndex to: aLine size.
	markerEnd := self markerEndIn: trimmed.
	markerEnd = 0 ifTrue: [ ^ self inlineStyle: aLine ].
	^ indent , (ansi color: (self colorAt: #listMarker)) , (trimmed copyFrom: 1 to: markerEnd) , ansi reset
	  , (self inlineStyle: (trimmed copyFrom: markerEnd + 1 to: trimmed size))
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> markerEndIn: aTrimmedLine [

	(aTrimmedLine beginsWith: '- ') ifTrue: [ ^ 2 ].
	(aTrimmedLine beginsWith: '* ') ifTrue: [ ^ 2 ].
	(aTrimmedLine beginsWith: '+ ') ifTrue: [ ^ 2 ].
	^ self orderedMarkerEndIn: aTrimmedLine
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> nextInlineTokenIn: aLine from: anIndex [

	| size character |
	size := aLine size.
	character := aLine at: anIndex.
	character = $\ ifTrue: [ ^ self escapeTokenIn: aLine from: anIndex ].
	(character = $~ and: [ anIndex < size and: [ (aLine at: anIndex + 1) = $~ ] ]) ifTrue: [
			^ self
				  tokenIn: aLine
				  from: anIndex
				  delimitedBy: '~~'
				  style: ansi strike ].
	character = $` ifTrue: [
			^ self
				  tokenIn: aLine
				  from: anIndex
				  delimitedBy: '`'
				  style: (ansi color: (self colorAt: #code)) ].
	(character = $* and: [ anIndex < size and: [ (aLine at: anIndex + 1) = $* ] ]) ifTrue: [
			^ self
				  tokenIn: aLine
				  from: anIndex
				  delimitedBy: '**'
				  style: ansi bold ].
	character = $* ifTrue: [
			^ self
				  tokenIn: aLine
				  from: anIndex
				  delimitedBy: '*'
				  style: ansi italic ].
	character = $[ ifTrue: [ ^ self linkTokenIn: aLine from: anIndex ].
	^ Array with: character asString with: anIndex + 1
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> orderedMarkerEndIn: aTrimmedLine [

	| index |
	index := 1.
	[ index <= aTrimmedLine size and: [ (aTrimmedLine at: index) isDigit ] ] whileTrue: [ index := index + 1 ].
	index = 1 ifTrue: [ ^ 0 ].
	index < aTrimmedLine size ifFalse: [ ^ 0 ].
	((aTrimmedLine at: index) = $. or: [ (aTrimmedLine at: index) = $) ]) ifFalse: [ ^ 0 ].
	aTrimmedLine at: index + 1 ifAbsent: [ ^ 0 ].
	^ index + 1
]

{ #category : 'accessing' }
PulsarLLMMarkdownStyler >> palette [

	^ palette
]

{ #category : 'accessing' }
PulsarLLMMarkdownStyler >> palette: anObject [

	palette := anObject
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> quoteStyle: aLine [

	| barIndex content |
	barIndex := aLine indexOf: $> startingAt: 1.
	barIndex = 0 ifTrue: [ ^ self inlineStyle: aLine ].
	content := (aLine copyFrom: barIndex + 1 to: aLine size) trimBoth.
	^ (ansi color: (self colorAt: #quote)) , '│ ' , ansi reset , (self inlineStyle: content)
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> ruleStyle [

	^ (ansi color: (self colorAt: #rule)) , '──────' , ansi reset
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> splitInlineTail: aLine [
	"Split a trailing partial line into renderable text and an unterminated inline tail."

	| unmatched |
	unmatched := self unmatchedDelimiterIndexIn: aLine.
	unmatched = 0 ifTrue: [ ^ Array with: aLine with: '' ].
	^ Array with: (aLine copyFrom: 1 to: unmatched - 1) with: (aLine copyFrom: unmatched to: aLine size)
]

{ #category : 'formatting' }
PulsarLLMMarkdownStyler >> stripMarkdown: aString [
	"Answer aString with the most common markdown markers removed."

	| result |
	result := aString.
	#( '```' '**' '`' ) do: [ :each | result := result copyReplaceAll: each with: '' ].
	^ result
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> tokenIn: aLine from: anIndex delimitedBy: aDelimiter style: anEscape [

	| start end inner |
	start := anIndex + aDelimiter size.
	end := aLine indexOfSubCollection: aDelimiter startingAt: start.
	end = 0 ifTrue: [ ^ Array with: (aLine at: anIndex) asString with: anIndex + 1 ].
	inner := aLine copyFrom: start to: end - 1.
	^ Array with: anEscape , inner , ansi reset with: end + aDelimiter size
]

{ #category : 'private' }
PulsarLLMMarkdownStyler >> unmatchedDelimiterIndexIn: aLine [

	| candidates |
	candidates := OrderedCollection new.
	#( '`' '**' '~~' ) do: [ :eachDelimiter |
		(self lastUnmatched: eachDelimiter in: aLine) ifNotNil: [ :eachIndex | candidates add: eachIndex ] ].
	candidates ifEmpty: [ ^ 0 ].
	^ candidates max
]
