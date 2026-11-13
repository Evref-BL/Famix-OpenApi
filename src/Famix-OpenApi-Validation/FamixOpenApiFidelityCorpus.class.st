"
The FamixOpenApiFidelityReport of several documents (a corpus), kept one by one (#reports: the verdict of every file) and merged (#merged: FamixOpenApiFidelityReport>>mergeWith:, the gaps, coverage and frequencies of all the files added up). #markdownSummary (LF line ends) is the report of the corpus: the verdict per file, the verdict of the whole, the failing gaps, the informational counts, the coverage per version, the frequency table of the fields and the candidates to model, the known findings about the importer and what is not verified.
"
Class {
	#name : 'FamixOpenApiFidelityCorpus',
	#superclass : 'Object',
	#instVars : [
		'reports'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiFidelityCorpus >> add: aFidelityReport [
	"The report of one more document"

	reports add: aFidelityReport.
	^ aFidelityReport
]

{ #category : 'initialization' }
FamixOpenApiFidelityCorpus >> initialize [

	super initialize.
	reports := OrderedCollection new
]

{ #category : 'accessing' }
FamixOpenApiFidelityCorpus >> isFaithful [
	"True when every document is"

	^ reports allSatisfy: [ :each | each isFaithful ]
]

{ #category : 'reporting' }
FamixOpenApiFidelityCorpus >> markdownSummary [
	"Markdown of the corpus: header, verdict, verdict per file, failing gaps, informational counts, coverage per version, frequency table and candidates to model, known importer findings, what is not verified. Lines end with LF"

	| all |
	all := self merged.
	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: '# Import fidelity report of the corpus';
			  lf.
		  all writeHeaderOn: stream.
		  all writeVerdictOn: stream.
		  self writeFilesOn: stream.
		  all writeFailingOn: stream.
		  all writeInformationalOn: stream.
		  all writeCoverageOn: stream.
		  all
			  writeSection:
			  'Fields that the metamodel does not model (frequencies)'
			  on: stream.
		  stream nextPutAll: all frequencies markdownSummary.
		  all writeFindingsOn: stream.
		  all writeNotVerifiedOn: stream ]
]

{ #category : 'accessing' }
FamixOpenApiFidelityCorpus >> merged [
	"One FamixOpenApiFidelityReport for the whole corpus: gaps, coverage and frequencies added up"

	| merged |
	merged := FamixOpenApiFidelityReport new.
	reports do: [ :each | merged absorb: each ].
	^ merged
]

{ #category : 'accessing' }
FamixOpenApiFidelityCorpus >> reports [
	"The FamixOpenApiFidelityReport of every document, in the order they were added"

	^ reports
]

{ #category : 'accessing' }
FamixOpenApiFidelityCorpus >> unfaithfulReports [
	"The reports of the documents that have a failing gap"

	^ reports reject: [ :each | each isFaithful ]
]

{ #category : 'reporting' }
FamixOpenApiFidelityCorpus >> writeFileRowOf: aReport on: aStream [

	aStream
		nextPutAll: '| ';
		nextPutAll:
			(aReport files
				 ifEmpty: [ '-' ]
				 ifNotEmpty: [ :names | names first ]);
		nextPutAll: ' | ';
		nextPutAll: aReport version;
		nextPutAll: ' | ';
		nextPutAll: (aReport isFaithful
				 ifTrue: [ 'faithful' ]
				 ifFalse: [ 'NOT faithful' ]);
		nextPutAll: ' | ';
		print: aReport failingGaps size;
		nextPutAll: ' | ';
		print: aReport informationalGaps size;
		nextPutAll: ' | ';
		print: aReport valuesCoverage totalCompared;
		nextPutAll: ' | ';
		print: aReport relationsCoverage totalCompared;
		nextPutAll: ' |';
		lf
]

{ #category : 'reporting' }
FamixOpenApiFidelityCorpus >> writeFilesOn: aStream [
	"One row per document: version, verdict, gaps, what the value and relation checks compared"

	FamixOpenApiFidelityReport
		writeSection: 'Verdict per file'
		on: aStream.
	aStream
		nextPutAll:
			'| File | Version | Verdict | Failing gaps | Informational gaps | Values compared | Relations compared |';
		lf;
		nextPutAll: '|---|---|---|---|---|---|---|';
		lf.
	reports do: [ :each | self writeFileRowOf: each on: aStream ]
]
