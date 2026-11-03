Class {
	#name : 'PvEntityProtocolTest',
	#superclass : 'TestCase',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'tests' }
PvEntityProtocolTest >> testEveryEntitySendIsInTheProtocol [

	| discipline protocol violations |
	discipline := PvModelEnvironmentDisciplineTest new.
	protocol := PulsarEntityProtocol selectors.
	violations := OrderedCollection new.
	(discipline modelClasses reject: [ :cls | cls == PvEnvironmentModel ]) do: [ :cls |
		cls selectors do: [ :sel |
			| ast |
			ast := (cls methodDictionary at: sel) ast.
			ast ifNotNil: [
				ast nodesDo: [ :node |
					((node isKindOf: OCMessageNode)
						and: [ discipline isEntityReceiver: node receiver ])
						ifTrue: [
							((protocol includes: node selector)
								or: [ discipline localOnlySelectors includes: node selector ])
								ifFalse: [
									violations add: cls name , '>>' , sel , ' sends #' , node selector ] ] ] ] ] ].
	self assert: violations isEmpty description: (violations joinUsing: ', ')
]
