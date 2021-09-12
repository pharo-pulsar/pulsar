Class {
	#name : #StExtensionProtocolModel,
	#superclass : #StVirtualProtocolModel,
	#category : #'NewTools-Browser-Model'
}

{ #category : #testing }
StExtensionProtocolModel class >> isForProtocol: aProtocol [ 

	^ aProtocol isExtensionProtocol
]

{ #category : #accessing }
StExtensionProtocolModel >> order [

	^ 200
]
