Extension { #name : 'TestSuite' }

{ #category : '*Pulsar-Tool-TestRunner' }
TestSuite >> announceTo: anAnnouncer during: aBlock [

	self testSuiteAnnouncer 
		when: TestCaseAnnouncement
		send: #announce: 
		to: anAnnouncer.
	
	^ aBlock ensure: [ 
		self testSuiteAnnouncer unsubscribe: anAnnouncer ]
]

{ #category : '*Pulsar-Tool-TestRunner' }
TestSuite >> debugAnnouncingTo: anAnnouncer [

	^ self 
		announceTo: anAnnouncer 
		during: [ self debug ]
]

{ #category : '*Pulsar-Tool-TestRunner' }
TestSuite >> runAnnouncingTo: anAnnouncer [

	^ self 
		announceTo: anAnnouncer 
		during: [ self run ]
]
