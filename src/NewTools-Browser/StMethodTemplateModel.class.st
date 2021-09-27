Class {
	#name : #StMethodTemplateModel,
	#superclass : #StBaseMethodModel,
	#instVars : [
		'methodClass'
	],
	#category : #'NewTools-Browser-Model-Method'
}

{ #category : #'instance creation' }
StMethodTemplateModel class >> newClass: aClass [ 

	^ self new 
		methodClass: aClass;
		yourself
]

{ #category : #testing }
StMethodTemplateModel >> isTemplate [

	^ true
]

{ #category : #accessing }
StMethodTemplateModel >> methodCategory [

	self flag: #TODO.
	^ Protocol unclassified
]

{ #category : #accessing }
StMethodTemplateModel >> methodClass [

	^ methodClass
]

{ #category : #accessing }
StMethodTemplateModel >> methodClass: aClass [

	methodClass := aClass
]

{ #category : #accessing }
StMethodTemplateModel >> name [

	^ 'new method'
]

{ #category : #accessing }
StMethodTemplateModel >> sourceCode [

	^ self methodClass sourceCodeTemplate
]
