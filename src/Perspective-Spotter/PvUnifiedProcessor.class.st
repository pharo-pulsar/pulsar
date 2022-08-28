Class {
	#name : #PvUnifiedProcessor,
	#superclass : #StSpotterProcessor,
	#instVars : [
		'categories',
		'sourceFactory',
		'label',
		'showForEmptyQuery'
	],
	#category : #'Perspective-Spotter-Model-Processor'
}

{ #category : #'default-settings' }
PvUnifiedProcessor class >> defaultEnabled [

	^ false
]

{ #category : #'instance creation' }
PvUnifiedProcessor class >> newEnvironment: anEnvironment [

	^ self newSourceFactory: (PvEnvironmentSourceFactory newEnvironment: anEnvironment)
]

{ #category : #'instance creation' }
PvUnifiedProcessor class >> newSourceFactory: aSourceFactory [

	^ self basicNew 
		sourceFactory: aSourceFactory;
		initialize;
		yourself
]

{ #category : #accessing }
PvUnifiedProcessor class >> order [
	
	^ 100
]

{ #category : #settings }
PvUnifiedProcessor class >> settingsDescription [

	^ 'I am the main processor: I show classes, packages and implementors'
]

{ #category : #settings }
PvUnifiedProcessor class >> settingsTitle [

	^ 'Classes, Implementors & Packages'
]

{ #category : #accessing }
PvUnifiedProcessor class >> title [

	^ 'Results'
]

{ #category : #sources }
PvUnifiedProcessor >> calculateLowercaseSourcesOn: anStream [
	| implementorsBeginsWith implementorsSubstring wordsAwareImplementors |

	(self categoriesIncludes: #Implementors) 
		ifFalse: [ ^ self ].

	implementorsBeginsWith := self sourceFactory implementorsBeginsWithSource.
	implementorsSubstring := self sourceFactory implementorsSubstringSource.
	wordsAwareImplementors := StWordsAwareFilter new 
		inner: (self sourceFactory implementorsSubstringSource); 
		yourself.
	
	textFilteringIterators add: implementorsBeginsWith.
	textFilteringIterators add: implementorsSubstring.
	textFilteringIterators add: wordsAwareImplementors.
	
	anStream nextPut: implementorsBeginsWith.
	anStream nextPut: implementorsSubstring.
	anStream nextPut: wordsAwareImplementors
]

{ #category : #sources }
PvUnifiedProcessor >> calculateUppercaseSourcesOn: anStream [
	| classesBeginsWith classesIncludesString packagesBeginsWith packagesIncludesString wordsAwareClassesSource wordsAwarePackageSource classAndSelectorImplementors |
	
	(self categoriesIncludes: #Classes) 
		ifTrue: [
			classesBeginsWith := self sourceFactory classesBeginsWithSource.			
			textFilteringIterators add: classesBeginsWith.
			anStream nextPut: classesBeginsWith ].

	(self categoriesIncludes: #Packages) 
		ifTrue: [
			packagesBeginsWith := (StPackageIterator new 
				collect: [ :each | StPackageEntry on: each ]) 
				asBeginsWithFilter.			
			textFilteringIterators add: packagesBeginsWith.
			anStream nextPut: packagesBeginsWith ].

	(self categoriesIncludes: #Classes) 
		ifTrue: [
			classesIncludesString := self sourceFactory classesSubstringSource.
			textFilteringIterators add: classesIncludesString.
			anStream nextPut: classesIncludesString ].
		
	(self categoriesIncludes: #Packages) 
		ifTrue: [
			packagesIncludesString := (StPackageIterator new 
				collect: [ :each | StPackageEntry on: each ]) 
				asSubstringFilter.		
			textFilteringIterators add: packagesIncludesString.
			anStream nextPut: packagesIncludesString ].
		
	(self categoriesIncludes: #Classes) 
		ifTrue: [
			wordsAwareClassesSource := StWordsAwareFilter new 
				inner: (self sourceFactory classesSubstringSource); 
				yourself.
			textFilteringIterators add: wordsAwareClassesSource.
			anStream nextPut: wordsAwareClassesSource ].

	(self categoriesIncludes: #Implementors) 
		ifTrue: 	[ 	
			classAndSelectorImplementors := StClassWithSelectorWordFilter new 
				inner: (StSourceFactory current implementorsSubstringSource); 
				yourself.
			textFilteringIterators add: classAndSelectorImplementors.
			anStream nextPut: classAndSelectorImplementors ].

	(self categoriesIncludes: #Packages) 
		ifTrue: [
			wordsAwarePackageSource := StWordsAwareFilter new 
				inner: ((StPackageIterator new 
					collect: [ :each | StPackageEntry on: each ]) 
					asSubstringFilter); 
				yourself.
			textFilteringIterators add: wordsAwarePackageSource.
			anStream nextPut: wordsAwarePackageSource ]
]

{ #category : #sources }
PvUnifiedProcessor >> categoriesIncludes: aCategory [

	^ categories isNil 
		or: [ categories isEmpty 
		or: [ (categories includes: aCategory)
		or: [ categories anySatisfy: [ :each | aCategory asLowercase beginsWith: each asLowercase ] ] ] ]
]

{ #category : #'spotter-api' }
PvUnifiedProcessor >> classesTag [

	^ #Classes
]

{ #category : #filtering }
PvUnifiedProcessor >> configureFilter [

	(categories ~= self query categoriesSelected)
		ifTrue: [
			categories := self query categoriesSelected.
			filter := nil ].
	super configureFilter.
	
	"I will clear the duplicates, as a new query have done"
	filter clearDuplicates
]

{ #category : #'accessing - ui' }
PvUnifiedProcessor >> headerCategoryFor: aLink on: aSpotterPresenter [

	^ aLink value 
		headerCategoryForUnifiedProcessor: aLink 
		on: aSpotterPresenter
]

{ #category : #'spotter-api' }
PvUnifiedProcessor >> implementorsTag [

	^ #Implementors
]

{ #category : #initialization }
PvUnifiedProcessor >> initialize [

	super initialize.
	self wantsToDisplayOnEmptyQuery: false
]

{ #category : #'key-bindings' }
PvUnifiedProcessor >> installKeymappingsOn: aPresenter onExecution: aBlock [

	aPresenter
		bindKeyCombination: $b meta
		toAction: [
			self query toggleFilter: self classesTag.
			aBlock cull: self ].

	aPresenter
		bindKeyCombination: $m meta
		toAction: [ 
			self query toggleFilter: self implementorsTag.
			aBlock cull: self ].
		
	aPresenter
		bindKeyCombination: $p meta
		toAction: [ 
			self query toggleFilter: self packagesTag.
			aBlock cull: self ]	
]

{ #category : #'spotter-api' }
PvUnifiedProcessor >> isRelevantForQuery: aString [ 
	
	^ true
]

{ #category : #'key-bindings' }
PvUnifiedProcessor >> keyBindingForClasses [

	^ $b meta
]

{ #category : #'key-bindings' }
PvUnifiedProcessor >> keyBindingForImplementors [

	^ $m meta
]

{ #category : #'key-bindings' }
PvUnifiedProcessor >> keyBindingForPackages [

	^ $p meta
]

{ #category : #accessing }
PvUnifiedProcessor >> label [

	^ label
]

{ #category : #accessing }
PvUnifiedProcessor >> label: aString [

	label := aString
]

{ #category : #'accessing - ui' }
PvUnifiedProcessor >> labelForClasses [

	^ '#Classes in {1}' format: { self label }
]

{ #category : #'accessing - ui' }
PvUnifiedProcessor >> labelForImplementors [

	^ '#Implementors in {1}' format: { self label }
]

{ #category : #'accessing - ui' }
PvUnifiedProcessor >> labelForPackages [

	^ '#Packages in {1}' format: { self label }
]

{ #category : #filtering }
PvUnifiedProcessor >> newSource [
	| uppercaseIterators lowercaseIterators caseSelectorIterator root |
	
	textFilteringIterators := OrderedCollection new.
	uppercaseIterators := OrderedCollection streamContents: [ :stream | 
		self calculateUppercaseSourcesOn: stream ].
	lowercaseIterators := OrderedCollection streamContents: [ :stream | 
		self calculateLowercaseSourcesOn: stream ].

	caseSelectorIterator := StCaseSelectorIterator new 
		lowercaseIterator: (StSequenceIterator with: lowercaseIterators);
		uppercaseIterator: (StSequenceIterator with: uppercaseIterators).
		
	textFilteringIterators add: caseSelectorIterator.
	
	root := caseSelectorIterator asWithoutDuplicates.
		
	^ root
]

{ #category : #filtering }
PvUnifiedProcessor >> newTextFilteringSource [
	"It should not arrive here"
	^ nil
]

{ #category : #'spotter-api' }
PvUnifiedProcessor >> packagesTag [

	^ #Packages
]

{ #category : #testing }
PvUnifiedProcessor >> showForEmptyQuery [

	^ showForEmptyQuery
]

{ #category : #accessing }
PvUnifiedProcessor >> sourceFactory [
	
	^ sourceFactory
]

{ #category : #accessing }
PvUnifiedProcessor >> sourceFactory: aSourceFactory [
	
	sourceFactory := aSourceFactory
]

{ #category : #accessing }
PvUnifiedProcessor >> wantsToDisplayOnEmptyQuery: aBoolean [
	
	showForEmptyQuery := aBoolean
]
