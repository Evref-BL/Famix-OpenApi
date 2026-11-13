"
Tests of FamixOpenApiFidelityReport: the failing and informational kinds (the union of the kinds of the four checks), the verdict, the markdown (sections, LF only, capped lists), merging of reports and the coverage per version.
"
Class {
	#name : 'FamixOpenApiFidelityReportTest',
	#superclass : 'FamixOpenApiFidelityTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiFidelityReportTest >> reportWithManyGaps [
	"A document checked against the model of another one: hundreds of failing gaps"

	^ FamixOpenApiFidelityChecker new
		  file: 'many.json';
		  checkJsonString: self documentOpenApi30
		  model: (self modelOf: self documentSwagger2)
		  diagnostics: nil
]

{ #category : 'tests - kinds' }
FamixOpenApiFidelityReportTest >> testAGapOfAnUnknownKindIsNotFaithful [

	| report gaps |
	report := FamixOpenApiFidelityReport new.
	gaps := FamixOpenApiGapReport new.
	gaps add:
		(FamixOpenApiGap kind: #somethingNew pointer: '#' specObject: nil).
	report addReport: gaps ofCheck: #values.
	self assert: report failingGaps isEmpty.
	self assert: report unclassifiedGaps size equals: 1.
	self deny: report isFaithful.
	self assert: (report markdownSummary includesSubstring:
			 'unclassified / somethingNew')
]

{ #category : 'tests - kinds' }
FamixOpenApiFidelityReportTest >> testAnInformationalGapDoesNotMakeTheReportUnfaithful [

	| report gaps |
	report := FamixOpenApiFidelityReport new.
	gaps := FamixOpenApiGapReport new.
	gaps add:
		(FamixOpenApiGap
			 kind: #onlyInExtensions
			 pointer: '#'
			 specObject: nil).
	report addReport: gaps ofCheck: #extensions.
	self assert: report isFaithful.
	self assert: report informationalGaps size equals: 1.
	self assert: report failingGaps isEmpty
]

{ #category : 'tests - merging' }
FamixOpenApiFidelityReportTest >> testMergingAddsUpTheDocumentsTheGapsTheCoverageAndTheFrequencies [

	| first second merged |
	first := self unifiedReportOf: self documentOpenApi30.
	second := self reportWithManyGaps.
	merged := first mergeWith: second.
	self assert: merged documents equals: 2.
	self
		assert: merged files
		equals: (OrderedCollection with: 'many.json').
	self assert: merged versions asArray equals: #( #v30 ).
	self
		assert: merged nodeCount
		equals: first nodeCount + second nodeCount.
	self
		assert: merged entityCount
		equals: first entityCount + second entityCount.
	self
		assert: merged gaps size
		equals: first gaps size + second gaps size.
	self assert: merged failingGaps size equals: second failingGaps size.
	self
		assert: merged coverage totalCompared
		equals: first coverage totalCompared + second coverage totalCompared.
	self
		assert: merged coverage totalLinks
		equals: first coverage totalLinks + second coverage totalLinks.
	self assert: merged frequencies sortedFields size
		>= first frequencies sortedFields size.
	self deny: merged isFaithful
]

{ #category : 'tests - merging' }
FamixOpenApiFidelityReportTest >> testMergingDoesNotChangeTheReportsThatAreMerged [

	| first second gapsBefore |
	first := self unifiedReportOf: self documentSwagger2.
	second := self reportWithManyGaps.
	gapsBefore := second gaps size.
	first mergeWith: second.
	self assert: second gaps size equals: gapsBefore.
	self assert: first documents equals: 1.
	self assert: first isFaithful.
	self assert: first versions asArray equals: #( #v2 )
]

{ #category : 'tests - merging' }
FamixOpenApiFidelityReportTest >> testMergingTheVersionsGivesMixedAndTheRowsOfEveryVersion [

	| merged text |
	merged := (self unifiedReportOf: self documentOpenApi30) mergeWith:
		          (self unifiedReportOf: self documentSwagger2).
	self assert: merged version equals: #mixed.
	self assert: merged versions asArray equals: #( #v30 #v2 ).
	text := merged markdownSummary.
	self assert: (text includesSubstring: '| v30 |').
	self assert: (text includesSubstring: '| v2 |').
	self deny: (text includesSubstring: '| v31 |')
]

{ #category : 'tests - markdown' }
FamixOpenApiFidelityReportTest >> testTheCountsByCheckAndKindAreInTheOrderOfTheChecks [

	| counts |
	counts := self reportWithManyGaps countsByCheckAndKind.
	self
		assert: counts keys
		equals: (FamixOpenApiFidelityReport reportNames select: [ :each |
				 counts includesKey: each ]).
	self assert: (counts at: #existence) isNotEmpty.
	self
		assert: (counts at: #existence) keys
		equals: (counts at: #existence) keys sorted
]

{ #category : 'tests - merging' }
FamixOpenApiFidelityReportTest >> testTheCoverageOfAVersionHoldsOnlyItsKeys [

	| merged v30 v2 |
	merged := (self unifiedReportOf: self documentOpenApi30) mergeWith:
		          (self unifiedReportOf: self documentSwagger2).
	v30 := merged coverageNumbersOf: 'v30'.
	v2 := merged coverageNumbersOf: 'v2'.
	self
		assert: v30 first
		equals:
			(self unifiedReportOf: self documentOpenApi30) valuesCoverage
				totalCompared.
	self
		assert: v2 first
		equals:
			(self unifiedReportOf: self documentSwagger2) valuesCoverage
				totalCompared.
	self
		assert: (merged coverageNumbersOf: 'v31')
		equals: #( 0 0 0 0 0 0 0 )
]

{ #category : 'tests - kinds' }
FamixOpenApiFidelityReportTest >> testTheFailingKindsAreTheUnionOfTheKindsOfTheFourChecks [
	"Existence (V7/V7b), values (V8), extensions (V9) and relations (V10), the preconditions and the document: the class side kinds of each check"

	| expected |
	expected := #( #missingEntity #extraEntity #unexpectedMultiple
	               #wrongClass #referenceNotResolved
	               #valueMismatch #countMismatch #lost #silentDrop
	               #relationMismatch #preconditionVersion
	               #preconditionMerged #invalidJson ) asSet.
	self
		assert: FamixOpenApiFidelityReport failingKinds asSet
		equals: expected.
	self
		assert: FamixOpenApiFidelityReport failingKinds size
		equals: expected size.
	self assert: (FamixOpenApiFidelityReport failingKinds includesAll:
			 FamixOpenApiGapReport failingKinds).
	self assert: (FamixOpenApiFidelityReport failingKinds includesAll:
			 FamixOpenApiGapReport relationKinds).
	self assert: (FamixOpenApiFidelityReport failingKinds includesAll:
			 FamixOpenApiFidelityReport existenceKinds).
	self assert: (FamixOpenApiFidelityReport failingKinds includesAll:
			 FamixOpenApiFidelityReport valueKinds).
	self assert: (FamixOpenApiFidelityReport failingKinds includesAll:
			 FamixOpenApiFidelityReport preconditionKinds)
]

{ #category : 'tests - kinds' }
FamixOpenApiFidelityReportTest >> testTheInformationalKindsAreTheOnesOfTheExtensionsCheckAndNeverFailing [

	self
		assert: FamixOpenApiFidelityReport informationalKinds asSet
		equals: #( #onlyInExtensions #ignoredByDiagnostic
			   #valueKeptAnyway #notDecidable ) asSet.
	self
		assert:
			(FamixOpenApiFidelityReport informationalKinds select: [ :each |
				 FamixOpenApiFidelityReport failingKinds includes: each ])
		equals: #(  )
]

{ #category : 'tests - kinds' }
FamixOpenApiFidelityReportTest >> testTheKindsOfEveryCheckAreClassified [
	"Every kind of gap that the checks give on the fixtures is failing or informational: nothing is unclassified"

	| kinds known |
	kinds := Set new.
	{
		self documentOpenApi30.
		self documentSwagger2.
		FamixOpenApiExtensionsTestCase new documentWrongTypes30.
		FamixOpenApiExtensionsTestCase new documentSiblings30.
		FamixOpenApiRelationTestCase new documentUnresolved30.
		FamixOpenApiRelationSwagger2Test new
			documentTypedParameterWithItemsAndSchema.
		FamixOpenApiRelationTestCase new documentSecurity31.
		FamixOpenApiRelationTestCase new documentCallbackThroughAliases }
		do: [ :each |
			| report |
			report := self unifiedReportOf: each.
			self assert: report unclassifiedGaps isEmpty.
			report gaps do: [ :gap | kinds add: gap kind ] ].
	self assert: (kinds includesAll:
			 #( #lost #silentDrop #onlyInExtensions #ignoredByDiagnostic
			    #relationMismatch #extraEntity )).
	known := (FamixOpenApiFidelityReport failingKinds
	          , FamixOpenApiFidelityReport informationalKinds) asSet.
	self assert: (known includesAll: kinds)
]

{ #category : 'tests - markdown' }
FamixOpenApiFidelityReportTest >> testTheMarkdownListsAtMostTenGapsPerCheckAndKindAndCountsTheOthers [

	| report text lines groupTitles |
	report := self reportWithManyGaps.
	text := report markdownSummary.
	self assert: report failingGaps size > 100.
	lines := text lines.
	groupTitles := lines select: [ :each | each beginsWith: '### ' ].
	self assert: groupTitles size >= 3.
	self assert:
		(lines count: [ :each | each beginsWith: '- many.json `' ])
		<= (10 * groupTitles size).
	self assert: (lines anySatisfy: [ :each |
			 each matchesRegex: '- \.\.\. and \d+ more' ]).
	self assert: text size < 40000
]

{ #category : 'tests - markdown' }
FamixOpenApiFidelityReportTest >> testTheMarkdownListsTheKnownImporterFindingsAndWhatIsNotVerified [

	| text |
	text := (self unifiedReportOf: self documentOpenApi30)
		        markdownSummary.
	FamixOpenApiFidelityReport knownImporterFindings
	, FamixOpenApiFidelityReport notVerified do: [ :each |
		self
			assert: (text includesSubstring: ('- {1}' format: { each }))
			description: each ]
]

{ #category : 'tests - markdown' }
FamixOpenApiFidelityReportTest >> testTheMarkdownOfAFaithfulReportHasTheSectionsAndOnlyLf [

	| text |
	text := (self unifiedReportOf: self documentOpenApi30)
		        markdownSummary.
	#( '# Import fidelity report' '- Documents: 1' '- Version: v30'
	   '- Source nodes: ' '- Checks run: existence, values, extensions, relations; skipped: none'
	   '**Verdict: FAITHFUL**' '## Failing gaps' '## Informational gaps'
	   '## Coverage per version' '| v30 |' '## Candidates to model'
	   '## Known importer findings' '## Not verified' ) do: [ :each |
		self assert: (text includesSubstring: each) description: each ].
	self deny: (text includes: Character cr).
	self assert: (text includes: Character lf).
	self assert: (text endsWith: (String with: Character lf))
]

{ #category : 'tests - markdown' }
FamixOpenApiFidelityReportTest >> testTheMarkdownOfAReportWhereNothingRanSaysSo [

	| text |
	text := (FamixOpenApiFidelityChecker new
		         checkJsonString: 'nope'
		         model: (self modelOf: self documentOpenApi30)
		         diagnostics: nil) markdownSummary.
	self assert: (text includesSubstring:
			 'Checks run: none; skipped: existence, values, extensions, relations').
	self assert:
		(text includesSubstring: '### document / invalidJson (1)').
	self assert: (text includesSubstring: 'Nothing compared.').
	self assert:
		(text includesSubstring:
			 '**Verdict: NOT FAITHFUL** (failing gaps: 1)')
]

{ #category : 'tests - markdown' }
FamixOpenApiFidelityReportTest >> testTheMarkdownOfAnUnfaithfulReportSaysWhoFailsAndHowMany [

	| text report |
	report := self reportWithManyGaps.
	text := report markdownSummary.
	self deny: report isFaithful.
	self assert:
		(text includesSubstring:
			 '**Verdict: NOT FAITHFUL** (failing gaps: '
			 , report failingGaps size printString , ')').
	self assert:
		(text includesSubstring: '### existence / missingEntity (').
	self assert: (text includesSubstring: '- many.json `#')
]

{ #category : 'tests - markdown' }
FamixOpenApiFidelityReportTest >> testThePreconditionGapIsInTheMarkdown [

	| doc text |
	doc := FamixOpenApiValidatorTestCase new richDocument.
	text := (FamixOpenApiFidelityChecker new
		         checkJsonString: doc
		         model: (self modelOf: doc merging: true)
		         diagnostics: nil) markdownSummary.
	self assert:
		(text includesSubstring:
			 '### preconditions / preconditionMerged (1)').
	self deny: (text includesSubstring: 'Checks run: existence')
]
