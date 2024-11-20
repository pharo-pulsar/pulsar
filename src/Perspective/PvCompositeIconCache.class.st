Class {
	#name : 'PvCompositeIconCache',
	#superclass : 'Object',
	#instVars : [
		'icons'
	],
	#category : 'Perspective-Icon',
	#package : 'Perspective',
	#tag : 'Icon'
}

{ #category : 'accessing' }
PvCompositeIconCache >> iconAt: aComposite [

	^ self iconAt: aComposite ifAbsent: [ NotFound signal ]
]

{ #category : 'accessing' }
PvCompositeIconCache >> iconAt: aComposite ifAbsent: aBlock [

	^ icons 
		at: aComposite fullName 
		ifAbsent: aBlock
]

{ #category : 'accessing' }
PvCompositeIconCache >> iconAt: aComposite put: anIcon [
	| gtkImage |

	"convert to GtkImage is just an optimisation (to not convert each time), but this  
	 makes the project 'gtk only' :/"
	self flag: #TODO. "I am leaking images, I think? (this is just to test it does not crashes, then I need to see how to free for real :P)"
	gtkImage := anIcon isForm 
		ifTrue: [ 
			GRunLoop defer: [ 
				anIcon asGtkImage 
					objectRef; 
					yourself ] ]
		ifFalse: [ anIcon ].
	
	^ icons 
		at: aComposite fullName 
		put: gtkImage
]

{ #category : 'initialization' }
PvCompositeIconCache >> initialize [

	super initialize.
	icons := SmallDictionary new
]
