"
Tests of the frequency table of the extensions check (V9: FamixOpenApiExtensionsReport, FamixOpenApiFieldFrequency) on small documents: the counts per field and kind, the top fields, the fields deferred to V10, the candidates to model and the fields never seen, the merge of several reports, the Markdown (LF line ends), and the separation of the informational and failing gaps of FamixOpenApiGapReport.
"
Class {
	#name : 'FamixOpenApiExtensionsReportTest',
	#superclass : 'FamixOpenApiExtensionsTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testCandidatesToModelAndFieldsNeverSeen [
	"The not modelled fields of the structural level that the documents have, with their frequency; the not modelled fields that no document has, apart"

	| table candidates never |
	table := (self extensionsReportOf: self documentExtensions30)
		         extensions.
	candidates := table candidatesToModel.
	self assert: candidates first fieldName equals: 'allowEmptyValue'.
	self assert: (candidates anySatisfy: [ :each |
			 each fieldName = 'parameters' and: [ each specObject = 'Link' ] ]).
	self assert:
		(candidates allSatisfy: [ :each | each level == #structural ]).
	self assert: (candidates allSatisfy: [ :each |
			 (table frequencyOfRow: each) total > 0 ]).
	never := table neverSeen.
	self assert: (never anySatisfy: [ :each |
			 each version = #v31 and: [ each fieldName = '$defs' ] ]).
	self assert:
		(never noneSatisfy: [ :each |
			 (table frequencyOfRow: each) total > 0 ]).
	self assert:
		(candidates noneSatisfy: [ :each | never includes: each ])
]

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testCountsByKindAndTopFields [

	| table counts top |
	table := (self extensionsReportOf: self documentExtensions31)
		         extensions.
	counts := table countsByKind.
	self assert: (counts at: #onlyInExtensions) equals: 25.
	self assert: (counts includesKey: #lost) not.
	self assert: (counts at: #deferred) > 0.
	top := table topFields: 3.
	self assert: top size equals: 3.
	self assert: (top collect: #total) asArray equals: #( 1 1 1 ).
	self
		assert: (table topFields: 1000) size
		equals: table sortedFields size.
	self assert:
		(table sortedFields allSatisfy: [ :each | each total > 0 ])
]

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testFrequencyOfTheFieldsOfASmallDocument [
	"Each occurrence counts once under its field: x-* is one field per spec object, an unknown key is its own field, a key beside a $ref is written so"

	| table |
	table := (self extensionsReportOf: self documentExtensions30)
		         extensions.
	self
		assert: (table frequencyOf: 'Info' field: 'x-*' in: #v30) total
		equals: 1.
	self
		assert: (table frequencyOf: 'Info' field: 'summary' in: #v30) total
		equals: 1.
	self
		assert: (table frequencyOf: 'OpenAPI' field: 'x-*' in: #v30) total
		equals: 1.
	self
		assert: (table frequencyOf: 'OpenAPI' field: 'zzz' in: #v30) total
		equals: 1.
	self
		assert:
		(table frequencyOf: 'Link' field: 'parameters' in: #v30) total
		equals: 1.
	self
		assert:
			((table frequencyOf: 'Link' field: 'parameters' in: #v30) countOf:
				 #onlyInExtensions)
		equals: 1.
	self
		assert:
		(table frequencyOf: 'Header' field: 'example' in: #v30) codes
		equals: #( #unmodelledKeyword ).
	self
		assert: (table frequencyOf: 'Info' field: 'summary' in: #v31) total
		equals: 0.
	table := (self extensionsReportOf: self documentSiblings30)
		         extensions.
	self assert: (table
			 frequencyOf: 'Parameter'
			 field: 'description (beside $ref)'
			 in: #v30) total >= 1.
	self
		assert:
			(table frequencyOf: 'Schema' field: 'title (beside $ref)' in: #v30)
				total
		equals: 1
]

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testInformationalAndFailingGapsArePartitioned [
	"#onlyInExtensions, #ignoredByDiagnostic, #valueKeptAnyway and #notDecidable are informational; #lost, #silentDrop and #valueMismatch fail"

	| report |
	report := self extensionsReportOf: self documentSiblings30.
	self
		assert: report informationalGaps size + report failingGaps size
		equals: report gaps size.
	self assert: (report informationalGaps allSatisfy: [ :each |
			 #( #onlyInExtensions #ignoredByDiagnostic ) includes: each kind ]).
	self assert:
		(report failingGaps allSatisfy: [ :each | each kind = #lost ]).
	self assert: report informationalGaps isNotEmpty.
	self assert: report failingGaps isNotEmpty.
	self
		assert: FamixOpenApiGapReport failingKinds asSet
		equals: #( #lost #silentDrop #valueMismatch ) asSet.
	self
		assert: FamixOpenApiGapReport informationalKinds asSet
		equals: #( #onlyInExtensions #ignoredByDiagnostic
			   #valueKeptAnyway #notDecidable ) asSet.
	self assert: (FamixOpenApiGapReport informationalKinds includesAny:
			 FamixOpenApiGapReport failingKinds) not.
	self
		assert: FamixOpenApiFieldFrequency kinds asSet
		equals: (FamixOpenApiGapReport failingKinds
			 , FamixOpenApiGapReport informationalKinds , #( #deferred )) asSet
]

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testMarkdownSummaryHasLfLineEndsAndTheSections [

	| text report |
	report := self extensionsReportOf: self documentSiblings30.
	text := report extensions markdownSummary.
	self deny: (text includes: Character cr).
	self assert: (text includesSubstring: '| Kind | Occurrences |').
	self assert: (text includesSubstring: 'Fields classified (V9)').
	self assert:
		(text includesSubstring: 'Candidates to model in the metamodel').
	self assert: (text includesSubstring: 'never seen').
	self assert: (text includesSubstring: 'Deferred to V10').
	self assert:
		(text includesSubstring:
			 '| v30 | `Schema.title (beside $ref)` | 1 |').
	text := report markdownSummary.
	self deny: (text includes: Character cr).
	self assert: (text includesSubstring: 'Fields classified (V9)')
]

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testTheCodesOfTheDiagnosticsSurviveTheMerge [
	"The Diagnostics column: merging the reports of the documents keeps the codes of each (the union), not only the counts"

	| first second merged frequency |
	first := FamixOpenApiExtensionsReport new.
	(first ensureFrequencyOf: 'Schema' field: 'title' in: #v30)
		recordKind: #ignoredByDiagnostic
		code: #refSiblingsIgnored.
	second := FamixOpenApiExtensionsReport new.
	(second ensureFrequencyOf: 'Schema' field: 'title' in: #v30)
		recordKind: #ignoredByDiagnostic
		code: #wrongNodeType.
	merged := FamixOpenApiExtensionsReport new.
	merged mergeWith: first.
	merged mergeWith: second.
	frequency := merged frequencyOf: 'Schema' field: 'title' in: #v30.
	self
		assert: frequency codes
		equals: #( #refSiblingsIgnored #wrongNodeType ).
	self assert: frequency total equals: 2.
	self assert: (frequency countOf: #ignoredByDiagnostic) equals: 2
]

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testTheFieldsOfRelationsAreDeferredToV10 [
	"The keys of relations and of implicit fields are counted as #deferred and are not classified: no gap, no total"

	| report table frequency |
	report := self extensionsReportOf: self documentExtensions30.
	table := report extensions.
	frequency := table
		             frequencyOf: 'Operation'
		             field: 'responses'
		             in: #v30.
	self assert: frequency deferredCount equals: 1.
	self assert: frequency total equals: 0.
	self assert: (table sortedFields includes: frequency) not.
	self assert:
		(report gaps noneSatisfy: [ :each | each fieldKey = 'responses' ]).
	self
		assert: (table frequencyOf: 'Schema' field: 'properties' in: #v30)
				deferredCount
		equals: 1
]

{ #category : 'tests' }
FamixOpenApiExtensionsReportTest >> testTwoReportsAreMerged [

	| first second merged |
	first := (self extensionsReportOf: self documentExtensions30)
		         extensions.
	second := (self extensionsReportOf: self documentSiblings30)
		          extensions.
	merged := FamixOpenApiExtensionsReport new.
	merged mergeWith: first.
	merged mergeWith: second.
	merged mergeWith: first.
	self
		assert: (merged frequencyOf: 'Info' field: 'x-*' in: #v30) total
		equals: 2.
	self
		assert:
			(merged frequencyOf: 'Schema' field: 'title (beside $ref)' in: #v30)
				total
		equals: 1.
	self
		assert: merged notModelledRows size
		equals: first notModelledRows size.
	self assert: merged notModelledRows isNotEmpty.
	self
		assert: (first frequencyOf: 'Info' field: 'x-*' in: #v30) total
		equals: 1
]
