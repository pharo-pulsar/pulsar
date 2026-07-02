Extension { #name : 'NewTestRunner' }

{ #category : '*Pulsar-Tool-TestRunner' }
NewTestRunner class >> executeSuite: aTestSuite announcingTo: anAnnouncer inMode: anExecutionMode [
    | runner testResult |

    runner := self new.
    runner suite: aTestSuite.
    runner executionMode: anExecutionMode.
    runner prepareSuite.

    aTestSuite announceTo: anAnnouncer during: [
        aTestSuite setUp.
        [
            aTestSuite tests do: [ :eachTest |
                eachTest prepareToRunOn: aTestSuite.
                [
                    testResult := anExecutionMode executeCase: eachTest.
                    runner result mergeWith: testResult ]
                ensure: [ eachTest cleanAfterRunOn: aTestSuite ] ] ]
        ensure: [ aTestSuite tearDown ] ].

    runner result dispatchResultsIntoHistory.
    runner tearDown.
    ^ runner result
]
