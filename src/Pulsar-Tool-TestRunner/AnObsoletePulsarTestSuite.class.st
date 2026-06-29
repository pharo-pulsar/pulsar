"
A test suite wrapping a TestCase subclass. Its entity is the Class.

Children are lazily-built PulsarTestCase instances, one per test selector.
"
Class {
	#name : 'AnObsoletePulsarTestSuite',
	#superclass : 'PulsarBaseTestModel',
	#instVars : [
		'cases'
	],
	#category : 'Pulsar-Tool-TestRunner',
	#package : 'Pulsar-Tool-TestRunner'
}
