"
I am the environment facade over a remote Pharo image.

Not implemented yet (Milestone 2). When implemented, my entity tokens will be proxy objects that understand only #= and #hash (by stable identity data, e.g. class name or class name + selector) and #printString. All data queries must go through my facade protocol; proxies must not be sent metamodel messages, because those would silently answer the local proxy protocol instead of the remote image data.
"
Class {
	#name : 'PulsarRemoteEnvironment',
	#superclass : 'PulsarEnvironment',
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'accessing' }
PulsarRemoteEnvironment >> name [

	^ 'Remote'
]
