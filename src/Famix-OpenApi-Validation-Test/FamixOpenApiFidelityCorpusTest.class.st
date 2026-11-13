"
The unified fidelity checker over the 20 files of the external corpus (merging off, the diagnostics of the import given): every file faithful, conservative lower bounds of the merged coverage and frequencies, the result equal to the four checks one by one, the corpus markdown. Skipped when the corpus folder is absent (see FamixOpenApiCorpusTest>>corpusFiles).
"
Class {
	#name : 'FamixOpenApiFidelityCorpusTest',
	#superclass : 'FamixOpenApiFidelityTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiFidelityCorpusTest >> corpus [
	"The FamixOpenApiFidelityCorpus of the files of the corpus"

	| corpus |
	corpus := FamixOpenApiFidelityCorpus new.
	self specFiles do: [ :each | corpus add: (self reportOfFile: each) ].
	^ corpus
]

{ #category : 'accessing' }
FamixOpenApiFidelityCorpusTest >> defaultTimeLimit [
	"The 20 files are imported and checked a few times (about 3 seconds each time)"

	^ 3 minutes
]

{ #category : 'helpers' }
FamixOpenApiFidelityCorpusTest >> reportOfFile: aFile [
	"The unified report of aFile imported without merging, with the diagnostics of the import"

	| importer |
	importer := self importerOn: aFile contents.
	^ FamixOpenApiFidelityChecker new
		  file: aFile basename;
		  checkJsonString: aFile contents
		  model: importer model
		  diagnostics: importer diagnostics all
]

{ #category : 'helpers' }
FamixOpenApiFidelityCorpusTest >> specFiles [
	"The corpus files that are API descriptions. Skips the running test when the corpus folder is absent"

	^ FamixOpenApiExistenceCorpusTest new specFiles
]

{ #category : 'tests' }
FamixOpenApiFidelityCorpusTest >> testTheCorpusHasTwentyFilesAndEveryOneIsFaithful [
	"VERIFIED: 20 files, merging off, the diagnostics of the import given: no failing gap, no gap of an unknown kind, the four checks ran"

	| corpus |
	corpus := self corpus.
	self assert: corpus reports size equals: 20.
	corpus reports do: [ :each |
		self assert: each isFaithful description: each files first.
		self assert: each failingGaps isEmpty description: each files first.
		self assert: each unclassifiedGaps isEmpty.
		self
			assert: each checksRun
			equals: FamixOpenApiFidelityChecker allChecks.
		self assert: each checksSkipped isEmpty ].
	self assert: corpus isFaithful.
	self assert: corpus unfaithfulReports isEmpty.
	self
		assert: corpus merged versions asArray sorted
		equals: #( #v2 #v30 #v31 )
]

{ #category : 'tests' }
FamixOpenApiFidelityCorpusTest >> testTheCorpusMarkdownHasOneRowPerFileAndTheSections [

	| text |
	text := self corpus markdownSummary.
	#( '# Import fidelity report of the corpus'
	   '- Documents: 20' '- Version: v2, v30, v31'
	   '**Verdict: FAITHFUL**' '## Verdict per file'
	   '## Failing gaps' '## Informational gaps' '## Coverage per version'
	   '| v30 |' '| v31 |' '| v2 |' '## Fields that the metamodel does not model (frequencies)'
	   '## Known importer findings' '## Not verified' ) do: [ :each |
		self assert: (text includesSubstring: each) description: each ].
	self specFiles do: [ :each |
		self
			assert: (text includesSubstring: '| ' , each basename , ' | ')
			description: each basename ].
	self deny: (text includes: Character cr).
	self assert: (text endsWith: (String with: Character lf))
]

{ #category : 'tests' }
FamixOpenApiFidelityCorpusTest >> testTheCorpusOnlyHasInformationalGaps [

	| merged |
	merged := self corpus merged.
	self assert: merged failingGaps isEmpty.
	self assert: merged gaps size equals: merged informationalGaps size.
	self
		assert: (merged gaps collect: #kind as: Set)
		equals: #( #onlyInExtensions #ignoredByDiagnostic ) asSet
]

{ #category : 'tests' }
FamixOpenApiFidelityCorpusTest >> testTheMergedCoverageHasConservativeLowerBounds [
	"Observed: 46642 values compared, 18757 relations compared in 158 rows, 5038 targets, 51 onlyInExtensions, 42 ignoredByDiagnostic, no relation deferred"

	| merged counts |
	merged := self corpus merged.
	self assert: merged valuesCoverage totalCompared >= 46000.
	self assert: merged relationsCoverage totalCompared >= 15000.
	self assert: merged relationsCoverage comparedKeys size >= 158.
	self assert: merged relationsCoverage totalLinks >= 4500.
	self assert: merged coverage totalCompared >= (46000 + 15000).
	self assert: merged coverage totalMismatched equals: 0.
	self assert: merged coverage totalDeferred equals: 0.
	counts := merged frequencies countsByKind.
	self assert: (counts at: #onlyInExtensions) >= 51.
	self assert: (counts at: #ignoredByDiagnostic) >= 42.
	self deny: (counts includesKey: #lost).
	self deny: (counts includesKey: #silentDrop)
]

{ #category : 'tests' }
FamixOpenApiFidelityCorpusTest >> testTheUnifiedResultIsTheOneOfTheFourChecksOneByOneOnEveryFile [
	"The gaps, the coverage totals and the frequencies of every check, file by file"

	self specFiles do: [ :each |
		self
			assertUnifiedEqualsIndividualFor: each contents
			named: each basename ]
]
