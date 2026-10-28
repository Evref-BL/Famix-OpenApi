"
Tests of FamixOpenApiPointerIndex: registration, aliases and reference resolution.
"
Class {
	#name : 'FamixOpenApiPointerIndexTest',
	#superclass : 'TestCase',
	#instVars : [
		'index',
		'diagnostics'
	],
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> assert: actual equals: expected description: aString [

	self
		assert: actual = expected
		description:
			aString , ' (expected ' , expected printString , ', got '
			, actual printString , ')'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> setUp [

	super setUp.
	diagnostics := FamixOpenApiDiagnostics new.
	index := FamixOpenApiPointerIndex diagnostics: diagnostics
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testAliasChainEndingOnWrongKindIsAMismatch [

	index register: OrderedCollection new at: '#/c'.
	index registerAlias: '#/a' to: '#/c'.
	self
		assert:
			(index resolveReference: '#/a' from: '#/x' expecting: Dictionary)
				isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #refKindMismatch)
		equals: 1
		description: 'count'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testAliasChainIsFollowedToTheEntity [

	| entity |
	entity := Object new.
	index register: entity at: '#/c'.
	index registerAlias: '#/a' to: '#/b'.
	index registerAlias: '#/b' to: '#/c'.
	self
		assert:
		(index resolveReference: '#/a' from: '#/x' expecting: nil) == entity
		description: 'entity'.
	self assert: diagnostics isEmpty description: 'no diagnostic'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testAliasIsIncludedAndRecognised [

	index registerAlias: '#/a' to: '#/b'.
	self assert: (index includesPointer: '#/a') description: 'included'.
	self assert: (index isAlias: '#/a') description: 'isAlias'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testAliasIsNotFollowedByLookup [

	index register: Object new at: '#/b'.
	index registerAlias: '#/a' to: '#/b'.
	self
		assert: (index lookup: '#/a') isNil
		description: 'alias lookup is nil'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testAliasToUnregisteredTargetIsUnresolved [

	index registerAlias: '#/a' to: '#/missing'.
	self
		assert:
		(index resolveReference: '#/a' from: '#/x' expecting: nil) isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #unresolvedReference)
		equals: 1
		description: 'count'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testChainWithinGuardIsResolved [

	| entity |
	entity := Object new.
	1 to: 20 do: [ :i |
		index
			registerAlias: '#/n' , i printString
			to: '#/n' , (i + 1) printString ].
	index register: entity at: '#/n21'.
	self
		assert:
			(index resolveReference: '#/n1' from: '#/site' expecting: nil)
			== entity
		description: 'entity'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testDefaultTranslationIsIdentity [

	| entity |
	entity := Object new.
	index register: entity at: '#/a'.
	self
		assert:
		(index resolveReference: '#/a' from: '#/x' expecting: nil) == entity
		description: 'identity'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testDiagnosticsConstructorKeepsTheGivenCollector [

	self
		assert: index diagnostics == diagnostics
		description: 'same collector'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testDuplicatePointerAnswersTheFirstEntity [

	| first second |
	first := OrderedCollection new.
	second := Array new: 3.
	index register: first at: '#/a'.
	self
		assert: (index register: second at: '#/a') == first
		description: 'answers first'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testDuplicatePointerDoesNotGrowTheIndex [

	index register: OrderedCollection new at: '#/a'.
	index register: Array new at: '#/a'.
	self assert: index size equals: 1 description: 'size'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testDuplicatePointerKeepsTheFirstEntity [

	| first second |
	first := OrderedCollection new.
	second := Array new: 3.
	index register: first at: '#/a'.
	index register: second at: '#/a'.
	self assert: (index lookup: '#/a') == first description: 'first kept'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testDuplicatePointerRecordsAWarning [

	| first second |
	first := OrderedCollection new.
	second := Array new: 3.
	index register: first at: '#/a'.
	index register: second at: '#/a'.
	self
		assert: (diagnostics countOf: #duplicatePointer)
		equals: 1
		description: 'count'.
	self
		assert: diagnostics warnings size
		equals: 1
		description: 'is a warning'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testEntitiesAnswersTheRegisteredEntities [

	| a b |
	a := OrderedCollection new.
	b := Array new: 2.
	index register: a at: '#/a'.
	index register: b at: '#/b'.
	index registerAlias: '#/c' to: '#/a'.
	self assert: index entities size equals: 2 description: 'size'.
	self
		assert: (index entities anySatisfy: [ :e | e == a ])
		description: 'has a'.
	self
		assert: (index entities anySatisfy: [ :e | e == b ])
		description: 'has b'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testEntityPointerIsNotAnAlias [

	index register: Object new at: '#/a'.
	self deny: (index isAlias: '#/a').
	self deny: (index isAlias: '#/absent')
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testForgetEntitiesKeepsTheOthersConsistent [
	"After forgetting, size, pointers, entities and lookup agree and keep the insertion order of the remaining ones."

	| a b c |
	a := Object new.
	b := Object new.
	c := Object new.
	index register: a at: '#/a'.
	index register: b at: '#/b'.
	index register: c at: '#/c'.
	index forgetEntities: (IdentitySet with: b).
	self assert: index size equals: 2 description: 'size'.
	self
		assert: index pointers
		equals: #( '#/a' '#/c' )
		description: 'pointers'.
	self
		assert: index entities size
		equals: 2
		description: 'entities size'.
	self assert: index entities first == a description: 'first entity'.
	self assert: index entities last == c description: 'last entity'.
	self assert: (index lookup: '#/a') == a description: 'lookup a'.
	self assert: (index lookup: '#/c') == c description: 'lookup c'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testForgetEntitiesLeavesAliasesUntouched [
	"An alias is not an entity: it stays registered even when its target is forgotten (it then no longer resolves)."

	| gone |
	gone := Object new.
	index register: gone at: '#/a'.
	index registerAlias: '#/alias' to: '#/a'.
	index forgetEntities: (IdentitySet with: gone).
	self assert: (index isAlias: '#/alias') description: 'alias kept'.
	self
		assert: index pointers
		equals: #( '#/alias' )
		description: 'pointers'.
	self assert: index size equals: 1 description: 'size'.
	self
		assert:
			(index resolveReference: '#/alias' from: '#/site' expecting: nil)
				isNil
		description: 'alias to a forgotten entity is unresolved'.
	self
		assert: (diagnostics withCode: #unresolvedReference) size
		equals: 1
		description: 'warning'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testForgetEntitiesRemovesEveryPointerOfTheEntity [

	| gone |
	gone := Object new.
	index register: gone at: '#/a'.
	index register: gone at: '#/b'.
	index forgetEntities: (IdentitySet with: gone).
	self assert: index size equals: 0 description: 'size'.
	self assert: index pointers equals: #(  ) description: 'pointers'.
	self assert: index entities isEmpty description: 'entities'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testForgetEntitiesRemovesThePointerOfTheEntity [

	| gone |
	gone := Object new.
	index register: gone at: '#/a'.
	index forgetEntities: (IdentitySet with: gone).
	self assert: (index lookup: '#/a') isNil description: 'lookup'.
	self deny: (index includesPointer: '#/a')
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testForgetEntitiesWithAnAbsentEntityHasNoEffect [

	| kept |
	kept := Object new.
	index register: kept at: '#/a'.
	index forgetEntities: (IdentitySet with: Object new).
	self assert: index size equals: 1 description: 'size'.
	self
		assert: index pointers
		equals: #( '#/a' )
		description: 'pointers'.
	self assert: (index lookup: '#/a') == kept description: 'lookup'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testForgetEntitiesWithAnEmptySetHasNoEffect [

	index register: Object new at: '#/a'.
	index forgetEntities: IdentitySet new.
	self assert: index size equals: 1 description: 'size'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testForgottenPointerCanBeRegisteredAgain [
	"Once forgotten, a pointer is free: a new entity can take it without a duplicatePointer warning."

	| gone fresh |
	gone := Object new.
	fresh := Object new.
	index register: gone at: '#/a'.
	index forgetEntities: (IdentitySet with: gone).
	index register: fresh at: '#/a'.
	self
		assert: (index lookup: '#/a') == fresh
		description: 'fresh registered'.
	self assert: index size equals: 1 description: 'size'.
	self
		assert: (diagnostics withCode: #duplicatePointer) isEmpty
		description: 'no warning'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testHttpReferenceIsUnresolved [

	self
		assert: (index
				 resolveReference: 'http://example.com/a.json'
				 from: '#/site'
				 expecting: nil) isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #unresolvedReference)
		equals: 1
		description: 'count'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testKindMismatchPointerIsTheSite [

	index register: OrderedCollection new at: '#/a'.
	index resolveReference: '#/a' from: '#/site' expecting: Dictionary.
	self
		assert: (diagnostics withCode: #refKindMismatch) first pointer
		equals: '#/site'
		description: 'pointer'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testLongNonLoopingChainBeyondGuardIsACycleError [

	1 to: 100 do: [ :i |
		index
			registerAlias: '#/n' , i printString
			to: '#/n' , (i + 1) printString ].
	index register: Object new at: '#/n101'.
	self
		assert:
		(index resolveReference: '#/n1' from: '#/site' expecting: nil) isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #refCycle)
		equals: 1
		description: 'count'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testLookupOfAbsentPointerAnswersNil [

	self assert: (index lookup: '#/absent') isNil description: 'nil'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testNewIndexHasItsOwnFreshDiagnostics [

	| fresh |
	fresh := FamixOpenApiPointerIndex new.
	self
		assert: fresh diagnostics isEmpty
		description: 'fresh diagnostics are empty'.
	self deny: fresh diagnostics == diagnostics
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testNewIndexIsEmpty [

	self assert: index size equals: 0 description: 'size'.
	self assert: index pointers equals: #(  ) description: 'pointers'.
	self assert: index entities isEmpty description: 'entities'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testNilReferenceIsUnresolved [

	self
		assert:
		(index resolveReference: nil from: '#/site' expecting: nil) isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #unresolvedReference)
		equals: 1
		description: 'count'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testNonLocalReferenceIsUnresolved [

	self
		assert:
			(index
				 resolveReference: 'other.json#/a'
				 from: '#/site'
				 expecting: nil) isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #unresolvedReference)
		equals: 1
		description: 'count'.
	self
		assert: (diagnostics withCode: #unresolvedReference) first pointer
		equals: '#/site'
		description: 'pointer'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testNonStringReferenceIsUnresolved [

	self
		assert:
		(index resolveReference: 42 from: '#/site' expecting: nil) isNil
		description: 'nil'.
	self
		assert:
		(index resolveReference: #( 1 ) from: '#/site' expecting: nil) isNil
		description: 'array nil'.
	self
		assert: (diagnostics countOf: #unresolvedReference)
		equals: 2
		description: 'count'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testPointersAnswersAnArray [

	index register: Object new at: '#/a'.
	self assert: index pointers class equals: Array description: 'class'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testPointersKeepInsertionOrder [

	index register: Object new at: '#/z'.
	index registerAlias: '#/m' to: '#/z'.
	index register: Object new at: '#/a'.
	self
		assert: index pointers
		equals: #( '#/z' '#/m' '#/a' )
		description: 'order'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testRegisterAnswersTheEntity [

	| entity |
	entity := Object new.
	self
		assert: (index register: entity at: '#/a') == entity
		description: 'answers entity'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testRegisterMakesPointerIncluded [

	index register: Object new at: '#/a'.
	self assert: (index includesPointer: '#/a') description: 'included'.
	self deny: (index includesPointer: '#/b')
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testRegisteredEntityCanBeLookedUp [

	| entity |
	entity := Object new.
	index register: entity at: '#/a'.
	self assert: (index lookup: '#/a') == entity description: 'lookup'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testRegisteringSameEntityTwiceAnswersIt [

	| entity |
	entity := Object new.
	index register: entity at: '#/a'.
	self
		assert: (index register: entity at: '#/a') == entity
		description: 'answers entity'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testRegisteringSameEntityTwiceIsANoOp [

	| entity |
	entity := Object new.
	index register: entity at: '#/a'.
	index register: entity at: '#/a'.
	self assert: index size equals: 1 description: 'size'.
	self assert: diagnostics isEmpty description: 'no diagnostic'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesIgnoresUnknownKeys [
	"A key of the dictionary that is not registered is ignored (no error, no new pointer)."

	| known |
	known := Object new.
	index register: known at: '#/a'.
	index replaceEntities: (IdentityDictionary new
			 at: Object new put: Object new;
			 yourself).
	self assert: (index lookup: '#/a') == known description: 'known kept'.
	self assert: index size equals: 1 description: 'size'.
	self assert: diagnostics isEmpty description: 'no diagnostic'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesKeepsOtherEntities [
	"An entity that is not a key of the dictionary stays where it is."

	| old new other |
	old := Object new.
	new := Object new.
	other := Object new.
	index register: old at: '#/a'.
	index register: other at: '#/b'.
	index replaceEntities: (IdentityDictionary new
			 at: old put: new;
			 yourself).
	self assert: (index lookup: '#/b') == other description: 'other kept'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesKeepsSizeAndPointersOrder [
	"Replacing entities changes neither the number nor the order of the pointers."

	| old new |
	old := Object new.
	new := Object new.
	index register: old at: '#/a'.
	index register: Object new at: '#/b'.
	index replaceEntities: (IdentityDictionary new
			 at: old put: new;
			 yourself).
	self assert: index size equals: 2 description: 'size'.
	self
		assert: index pointers
		equals: #( '#/a' '#/b' )
		description: 'pointers'.
	self
		assert: index entities first == new
		description: 'entities order'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesLeavesAliasesUntouched [
	"An alias is a raw reference String, not an entity: replacing entities does not change it and it still resolves through the redirected pointer."

	| old new |
	old := Object new.
	new := Object new.
	index register: old at: '#/a'.
	index registerAlias: '#/alias' to: '#/a'.
	index replaceEntities: (IdentityDictionary new
			 at: old put: new;
			 yourself).
	self assert: (index isAlias: '#/alias') description: 'still alias'.
	self assert: index size equals: 2 description: 'size'.
	self
		assert:
			(index resolveReference: '#/alias' from: '#/site' expecting: nil)
			== new
		description: 'alias resolves to the new entity'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesRedirectsEveryPointerOfTheOldEntity [
	"A merged entity may be registered at several pointers: all of them are redirected."

	| old new |
	old := Object new.
	new := Object new.
	index register: old at: '#/a'.
	index register: old at: '#/b'.
	index replaceEntities: (IdentityDictionary new
			 at: old put: new;
			 yourself).
	self
		assert: (index lookup: '#/a') == new
		description: 'first pointer'.
	self
		assert: (index lookup: '#/b') == new
		description: 'second pointer'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesRedirectsThePointerOfTheOldEntity [
	"replaceEntities: makes the pointers that held an old entity hold the new one."

	| old new |
	old := Object new.
	new := Object new.
	index register: old at: '#/a'.
	index replaceEntities: (IdentityDictionary new
			 at: old put: new;
			 yourself).
	self assert: (index lookup: '#/a') == new description: 'redirected'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesUsesIdentityNotEquality [
	"Two equal but distinct entities are different keys: only the identical one is replaced."

	| old twin new |
	old := OrderedCollection new.
	twin := OrderedCollection new.
	new := Object new.
	index register: old at: '#/a'.
	index register: twin at: '#/b'.
	index replaceEntities: (IdentityDictionary new
			 at: old put: new;
			 yourself).
	self
		assert: (index lookup: '#/a') == new
		description: 'identical replaced'.
	self
		assert: (index lookup: '#/b') == twin
		description: 'equal twin kept'
]

{ #category : 'tests - replace and forget' }
FamixOpenApiPointerIndexTest >> testReplaceEntitiesWithAnEmptyDictionaryChangesNothing [

	| entity |
	entity := Object new.
	index register: entity at: '#/a'.
	index replaceEntities: IdentityDictionary new.
	self assert: (index lookup: '#/a') == entity description: 'kept'.
	self assert: index size equals: 1 description: 'size'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testResetEmptiesTheIndex [

	index register: Object new at: '#/a'.
	index registerAlias: '#/b' to: '#/a'.
	index reset.
	self assert: index size equals: 0 description: 'size'.
	self assert: index pointers equals: #(  ) description: 'pointers'.
	self deny: (index includesPointer: '#/a')
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testResolveAcceptsASubclassInstanceOfTheExpectedKind [

	| entity |
	entity := OrderedCollection new.
	index register: entity at: '#/a'.
	self
		assert:
			(index resolveReference: '#/a' from: '#/x' expecting: Collection)
			== entity
		description: 'subclass accepted'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testResolveLocalReferenceAnswersTheEntity [

	| entity |
	entity := Object new.
	index register: entity at: '#/components/schemas/A'.
	self
		assert: (index
				 resolveReference: '#/components/schemas/A'
				 from: '#/x'
				 expecting: nil) == entity
		description: 'entity'.
	self assert: diagnostics isEmpty description: 'no diagnostic'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testResolveUnregisteredRecordsAWarningAndAnswersNil [

	self
		assert:
		(index resolveReference: '#/nope' from: '#/site' expecting: nil)
			isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #unresolvedReference)
		equals: 1
		description: 'count'.
	self
		assert: diagnostics warnings size
		equals: 1
		description: 'is a warning'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testResolveWithMatchingKindAnswersTheEntity [

	| entity |
	entity := OrderedCollection new.
	index register: entity at: '#/a'.
	self
		assert: (index
				 resolveReference: '#/a'
				 from: '#/x'
				 expecting: OrderedCollection) == entity
		description: 'entity'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testResolveWithWrongKindRecordsAnErrorAndAnswersNil [

	index register: OrderedCollection new at: '#/a'.
	self
		assert:
			(index resolveReference: '#/a' from: '#/x' expecting: Dictionary)
				isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #refKindMismatch)
		equals: 1
		description: 'count'.
	self
		assert: diagnostics errors size
		equals: 1
		description: 'is an error'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testResolveWorksWithRealMetamodelEntities [

	| schema |
	schema := OPSchema new.
	index register: schema at: '#/components/schemas/S'.
	self
		assert: (index
				 resolveReference: '#/components/schemas/S'
				 from: '#/x'
				 expecting: OPSchema) == schema
		description: 'schema'.
	self
		assert: (index
				 resolveReference: '#/components/schemas/S'
				 from: '#/x'
				 expecting: OPParameter) isNil
		description: 'wrong kind'.
	self
		assert: (diagnostics countOf: #refKindMismatch)
		equals: 1
		description: 'mismatch'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testSelfAliasIsACycle [

	index registerAlias: '#/a' to: '#/a'.
	self
		assert:
		(index resolveReference: '#/a' from: '#/site' expecting: nil) isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #refCycle)
		equals: 1
		description: 'count'.
	self
		assert: diagnostics errors size
		equals: 1
		description: 'is an error'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testSingleAliasIsFollowedToTheEntity [

	| entity |
	entity := Object new.
	index register: entity at: '#/b'.
	index registerAlias: '#/a' to: '#/b'.
	self
		assert:
		(index resolveReference: '#/a' from: '#/x' expecting: nil) == entity
		description: 'entity'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testSizeCountsEntitiesAndAliases [

	index register: Object new at: '#/a'.
	index registerAlias: '#/b' to: '#/a'.
	self assert: index size equals: 2 description: 'size'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testTranslateRefsWithRewritesTheRawReference [

	| entity |
	entity := Object new.
	index register: entity at: '#/components/schemas/A'.
	index translateRefsWith: [ :ref |
		ref copyReplaceAll: '#/definitions/' with: '#/components/schemas/' ].
	self
		assert:
			(index
				 resolveReference: '#/definitions/A'
				 from: '#/x'
				 expecting: nil) == entity
		description: 'translated'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testTranslationAppliesToAliasTargets [

	| entity |
	entity := Object new.
	index register: entity at: '#/components/schemas/A'.
	index registerAlias: '#/components/schemas/B' to: '#/definitions/A'.
	index translateRefsWith: [ :ref |
		ref copyReplaceAll: '#/definitions/' with: '#/components/schemas/' ].
	self
		assert: (index
				 resolveReference: '#/components/schemas/B'
				 from: '#/x'
				 expecting: nil) == entity
		description: 'alias translated'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testTwoAliasLoopIsACycleReportedAtTheSite [

	index registerAlias: '#/a' to: '#/b'.
	index registerAlias: '#/b' to: '#/a'.
	self
		assert:
		(index resolveReference: '#/a' from: '#/site' expecting: nil) isNil
		description: 'nil'.
	self
		assert: (diagnostics countOf: #refCycle)
		equals: 1
		description: 'count'.
	self
		assert: (diagnostics withCode: #refCycle) first pointer
		equals: '#/site'
		description: 'pointer'
]

{ #category : 'tests' }
FamixOpenApiPointerIndexTest >> testUnresolvedPointerIsTheSite [

	index resolveReference: '#/nope' from: '#/site' expecting: nil.
	self
		assert: (diagnostics withCode: #unresolvedReference) first pointer
		equals: '#/site'
		description: 'pointer'
]
