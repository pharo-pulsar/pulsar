Class {
	#name : 'DockSnapshotTest',
	#superclass : 'DockBaseViewTest',
	#category : 'Dock-Browser-Tests',
	#package : 'Dock-Browser-Tests'
}

{ #category : 'tests' }
DockSnapshotTest >> testSnapshotJustOpened [
	| snapshot |

	self openBrowser.
	snapshot := browser snapshot.
	self assert: snapshot isNotNil.
	"project, stack, transcript, playground and outline"
	self assert: snapshot panels size equals: 5
	
]

{ #category : 'tests' }
DockSnapshotTest >> testSnapshotPlaygroundKeepsText [
	| snapshot playground panelSnapshot |

	self openBrowser.

	playground := browser presenterWithClass: DockPlayground.
	playground presenter contents: '42 factorial'.

	snapshot := browser snapshot.
	self assert: snapshot isNotNil.

	panelSnapshot := snapshot panelWithClass: DockPlaygroundSnapshotRecord.
	self assert: panelSnapshot isNotNil.
	self assert: panelSnapshot contents equals: '42 factorial'	

]
