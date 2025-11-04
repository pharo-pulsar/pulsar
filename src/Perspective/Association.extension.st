Extension { #name : 'Association' }

{ #category : '*Perspective' }
Association >> asPvAction [
	"this is to handle constructions style 
	 shortcut -> action"

	^ self value 
		shortcutKey: self key;
		yourself
]
