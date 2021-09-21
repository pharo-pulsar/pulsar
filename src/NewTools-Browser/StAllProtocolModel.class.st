Class {
	#name : #StAllProtocolModel,
	#superclass : #StVirtualProtocolModel,
	#category : #'NewTools-Browser-Model-Protocol'
}

{ #category : #testing }
StAllProtocolModel class >> isForProtocol: aProtocol [ 

	^ aProtocol isAllProtocol
]

{ #category : #accessing }
StAllProtocolModel >> order [

	^ 0
]
