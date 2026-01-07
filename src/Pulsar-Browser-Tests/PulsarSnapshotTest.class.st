Class {
	#name : 'PulsarSnapshotTest',
	#superclass : 'PulsarBaseViewTest',
	#category : 'Pulsar-Browser-Tests',
	#package : 'Pulsar-Browser-Tests'
}

{ #category : 'tests' }
PulsarSnapshotTest >> testSnapshotJustOpened [
	| snapshot |

	self openBrowser.
	snapshot := browser snapshot.
	self assert: snapshot isNotNil.
	"project, stack, transcript, playground and outline"
	self assert: snapshot snapshots size equals: 5
	
]

{ #category : 'tests' }
PulsarSnapshotTest >> testSnapshotPlaygroundKeepsText [
	| snapshot playground panelSnapshot |

	self openBrowser.

	playground := browser presenterWithClass: PulsarPlayground.
	playground presenter contents: '42 factorial'.
	playground presenter codePresenter cursorPositionIndex: 3.

	snapshot := browser snapshot.
	self assert: snapshot isNotNil.

	panelSnapshot := snapshot snapshotWithClass: PulsarPlaygroundSnapshot.
	self assert: panelSnapshot isNotNil.
	self assert: panelSnapshot contents equals: '42 factorial'.
	self assert: panelSnapshot cursorPositionIndex equals: 3.	
]
