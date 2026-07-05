Extension { #name : 'PvBaseModel' }

{ #category : '*Pulsar-Tool-TestRunner' }
PvBaseModel >> findTestRunnerProjectIn: anApplication [
	"Search all windows of anApplication for one containing self
	 in its project tree. Returns the PulsarBaseProjectModel root,
	 or nil if self is not part of any opened project."

	anApplication windows 
		select: [ :eachWindow | eachWindow isPulsarBrowser ]
		thenDo: [ :eachWindow |
			| projectView |
			projectView := eachWindow findPresenterClass: PulsarProjectView.
			projectView ifNotNil: [
				| root |
				root := projectView model findRootForEntity: self.
				root isProject ifTrue: [ ^ root ] ] ].

	^ nil
]
