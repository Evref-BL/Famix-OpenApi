"
The extensions check over the twenty files of the corpus (OpenAPI 3.0, 3.1, Swagger 2), merging off, with the diagnostics of the importer: nothing is lost or dropped (the frozen list of real findings is empty), and the frequency table has the fields that the importer keeps in the extensions or reports. Skipped when the corpus folder is absent.
"
Class {
	#name : 'FamixOpenApiExtensionsCorpusTest',
	#superclass : 'FamixOpenApiExtensionsTestCase',
	#instVars : [
		'reports'
	],
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'accessing' }
FamixOpenApiExtensionsCorpusTest >> defaultTimeLimit [
	"Twenty files are imported and checked"

	^ 2 minutes
]

{ #category : 'helpers' }
FamixOpenApiExtensionsCorpusTest >> failingFindings [
	"The rows (file name, pointer, key, kind) of the gaps that are failures, whatever the kind"

	^ Array streamContents: [ :stream |
		  self reports do: [ :each |
			  each value failingGaps do: [ :gap |
				  stream nextPut: {
						  each key.
						  gap sourcePointer.
						  gap fieldKey.
						  gap kind } ] ] ]
]

{ #category : 'helpers' }
FamixOpenApiExtensionsCorpusTest >> frozenFindings [
	"Rows: file name, pointer, key, kind. Empty: every key of the twenty files that the metamodel does not model is in the extensions of its entity (or, beside a $ref the importer ignores, said by refSiblingsIgnored), and no value of a wrong type is dropped without a diagnostic. VERIFIED by running the check; the importer was not changed to get there. The 3.1 siblings of a $ref that nothing keeps (known importer gap 2) do not occur in the corpus: the fixtures of the check test freeze them"

	^ #(  )
]

{ #category : 'helpers' }
FamixOpenApiExtensionsCorpusTest >> mergedTable [
	"The frequency tables of the twenty files in one"

	| table |
	table := FamixOpenApiExtensionsReport new.
	self reports do: [ :each | table mergeWith: each value extensions ].
	^ table
]

{ #category : 'helpers' }
FamixOpenApiExtensionsCorpusTest >> reportOfFile: aFile [
	"The report of the extensions check of aFile imported without merging, with the diagnostics of the importer"

	| imported |
	imported := self importedOf: aFile contents.
	^ (FamixOpenApiExtensionsCheck new
		   file: aFile basename;
		   yourself)
		  checkInventory: (self inventoryOf: aFile contents)
		  model: imported first
		  diagnostics: imported last
]

{ #category : 'helpers' }
FamixOpenApiExtensionsCorpusTest >> reports [
	"Associations file name -> report, for every spec file of the corpus (computed once per test)"

	^ reports ifNil: [
		  reports := self specFiles collect: [ :file |
			             file basename -> (self reportOfFile: file) ] ]
]

{ #category : 'helpers' }
FamixOpenApiExtensionsCorpusTest >> specFiles [
	"The corpus files that are API descriptions. Skips the running test when the corpus folder is absent"

	^ FamixOpenApiExistenceCorpusTest new specFiles
]

{ #category : 'tests' }
FamixOpenApiExtensionsCorpusTest >> testCorpusFailingFindingsAreExactlyTheFrozenOnes [

	self assert: self reports size equals: 20.
	self
		assert: self failingFindings asSet
		equals: self frozenFindings asSet.
	self
		assert: self failingFindings size
		equals: self frozenFindings size
]

{ #category : 'tests' }
FamixOpenApiExtensionsCorpusTest >> testEveryGapOfTheCorpusSaysWhereTheKeyIsKeptOrWhoReportsIt [
	"With the diagnostics given, nothing is undecidable, and the informational gaps are the two kinds that say so"

	| kinds |
	kinds := Set new.
	self reports do: [ :each |
		each value gaps do: [ :gap | kinds add: gap kind ] ].
	self
		assert: kinds
		equals: #( #onlyInExtensions #ignoredByDiagnostic ) asSet
]

{ #category : 'tests' }
FamixOpenApiExtensionsCorpusTest >> testTheCandidatesToModelAndTheFieldsNeverSeen [
	"Structural fields the metamodel does not model and the corpus has: Link.parameters (3.0), Header.type and Header.format (Swagger 2); the others (all the 3.1 keywords, for one) are never seen"

	| table candidates seen |
	table := self mergedTable.
	candidates := table candidatesToModel collect: [ :each |
		              each fieldName ].
	self assert: candidates size >= 3.
	self assert: (candidates includes: 'parameters').
	self assert: (candidates includes: 'type').
	seen := table neverSeen collect: [ :each | each fieldName ].
	self assert: seen size >= 40.
	self assert: (seen includes: '$defs').
	self deny: (seen includes: 'type')
]

{ #category : 'tests' }
FamixOpenApiExtensionsCorpusTest >> testTheCountsOfTheKindsHaveConservativeLowerBounds [
	"Observed: 51 onlyInExtensions, 42 ignoredByDiagnostic, 1236 deferred"

	| counts |
	counts := self mergedTable countsByKind.
	self assert: (counts at: #onlyInExtensions) >= 40.
	self assert: (counts at: #ignoredByDiagnostic) >= 30.
	self assert: (counts at: #deferred) >= 1000.
	self deny: (counts includesKey: #lost).
	self deny: (counts includesKey: #silentDrop).
	self deny: (counts includesKey: #notDecidable)
]

{ #category : 'tests' }
FamixOpenApiExtensionsCorpusTest >> testTheMarkdownSummaryOfTheCorpusHasTheSectionsAndLfLineEnds [

	| text |
	text := self mergedTable markdownSummary.
	self deny: (text includes: Character cr).
	self assert: (text includesSubstring: 'Candidates to model').
	self assert: (text includesSubstring: 'never seen').
	self assert: (text includesSubstring: 'Deferred to V10')
]

{ #category : 'tests' }
FamixOpenApiExtensionsCorpusTest >> testTheMostFrequentFieldsAreTheExtensionsOfTheInfoAndTheSiblingsOfARef [
	"Observed: Schema.description beside a $ref (Swagger 2) 41, Info.x-* 25 (3.0) and 9 (Swagger 2), Link.parameters 4"

	| table |
	table := self mergedTable.
	self assert: (table
			 frequencyOf: 'Schema'
			 field: 'description (beside $ref)'
			 in: #v2) total >= 30.
	self assert:
		(table frequencyOf: 'Info' field: 'x-*' in: #v30) total >= 20.
	self assert:
		(table frequencyOf: 'Info' field: 'x-*' in: #v2) total >= 5.
	self assert:
		(table frequencyOf: 'Link' field: 'parameters' in: #v30) total >= 3.
	self assert: (table topFields: 25) size >= 8.
	self assert: (table topFields: 1) first total >= 30
]
