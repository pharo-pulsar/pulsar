Class {
	#name : 'PulsarEntityProtocol',
	#superclass : 'Object',
	#category : 'Perspective',
	#package : 'Perspective'
}

{ #category : 'protocol' }
PulsarEntityProtocol class >> selectors [

	"The metamodel protocol that Pv models send to their entity.
	 Remote entity proxies must implement these messages.
	 Local-only operations (compilation, AST, execution, Metacello, Iceberg)
	 are intentionally excluded and handled through environment capabilities."
	^ #(#= #'>>' #addClassVarNamed: #addProtocol: #addSlot:
		#allSuperclasses #allTestSelectors #argumentNames
		#classCommentBlank #classDepth #classSide
		#classes #classesForClassTag: #comment #comment:
		#definedClasses #definingClass #ensureTag: #extendedClasses
		#hasPragmaNamed: #hash #ifNil: #instanceSide
		#isAbstract #isClassOrTrait #isClassSide #isDeprecated #isRoot
		#isTestCase #isTestMethod #isUnclassifiedProtocol
		#methodClass #methods #name #origin #owningClass
		#package #packageManifest #packageManifestOrNil #packageTag
		#pragmas #protocol #protocol: #removeFromSystem #renameTo:
		#selector #selector: #sourceCode #systemIconName #tags #traits
		#users #variableNodes)
]
