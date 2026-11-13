"
The answer of FamixOpenApiFidelityChecker: what the four import-fidelity checks found on one source document and its imported model (or, merged with #mergeWith:, on several documents).

PARTS. One FamixOpenApiGapReport per check that ran, by check name (#reportOfCheck:): #existence (V7/V7b), #values (V8), #extensions (V9), #relations (V10), plus #preconditions (one #preconditionMerged or #preconditionVersion gap: then the four checks were skipped, #checksSkipped) and #document (one #invalidJson gap: the text was not JSON).

GAPS. #gaps (all), #gapsOfCheck:, #failingGaps, #informationalGaps. The kinds are DATA of the class side: #failingKinds is the union of the kinds of the checks (existence: #missingEntity #extraEntity #unexpectedMultiple #wrongClass #referenceNotResolved; values: #valueMismatch #countMismatch; extensions: FamixOpenApiGapReport class>>failingKinds #lost #silentDrop #valueMismatch; relations: FamixOpenApiGapReport class>>relationKinds #relationMismatch #countMismatch; the preconditions and #invalidJson), #informationalKinds is the one of FamixOpenApiGapReport (#onlyInExtensions #ignoredByDiagnostic #valueKeptAnyway #notDecidable: they say what became of a field and are not failures). #isFaithful is true when no gap is failing and no gap has an unknown kind (#unclassifiedGaps); a check that was skipped or not selected says nothing, see #checksRun.

NUMBERS. #countsByCheckAndKind, #coverage (the coverage of the checks merged: values compared, relations compared, targets, deferred relations with their reason), #frequencies (FamixOpenApiExtensionsReport: what became of every field that the metamodel does not model as a slot), #knownImporterFindings (data: what the checks know about the importer, so that a verdict is read with it), #markdownSummary (LF line ends: header, verdict, failing gaps by check and kind capped, informational counts, coverage per version, candidates to model, known importer findings, what is not verified).
"
Class {
	#name : 'FamixOpenApiFidelityReport',
	#superclass : 'Object',
	#instVars : [
		'files',
		'versions',
		'documents',
		'nodeCount',
		'entityCount',
		'reports',
		'skipped'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> checkNames [
	"The four checks, in the order they are reported"

	^ #( #existence #values #extensions #relations )
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> documentKinds [
	"The kinds of gap about the text of the document: it is not JSON"

	^ #( #invalidJson )
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> existenceKinds [
	"The kinds of gap of the existence check (V7/V7b), all failures"

	^ #( #missingEntity #extraEntity #unexpectedMultiple
	     #wrongClass #referenceNotResolved )
]

{ #category : 'data - findings' }
FamixOpenApiFidelityReport class >> extensionsFindings [
	"The real importer findings of the extensions check (V9), classified #lost on purpose (see the comment of FamixOpenApiExtensionsCheck): a gap of these is not a bug of the check"

	^ #( 'The siblings of a parameter, request body, response, header or link with a $ref at a use site (OpenAPI 3.0 and 3.1): no diagnostic, nothing kept.'
	     'nullable true of a schema in OpenAPI 3.1 and Swagger 2: neither a slot nor an extension.'
	     'The x-* keys of the Paths, Responses and OAuthFlows containers: no slot, no extensions.'
	     'The x-* keys of a formData parameter of an operation without body or of a path item: no diagnostic.'
	     'maximum with a text (a value of a wrong JSON type): dropped without a diagnostic (silentDrop).' )
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> failingKinds [
	"The kinds of gap that make a report unfaithful: the union of the kinds of the four checks (the existence and value ones above, FamixOpenApiGapReport class>>failingKinds for V9 and FamixOpenApiGapReport class>>relationKinds for V10), the preconditions and the document"

	^ (self existenceKinds , self valueKinds , self preconditionKinds
	   , self documentKinds , FamixOpenApiGapReport failingKinds
	   , FamixOpenApiGapReport relationKinds) asSet asArray sorted
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> gapsShownPerGroup [
	"How many gaps of a check and kind the markdown summary lists, the others are counted"

	^ 10
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> informationalKinds [
	"The kinds of gap that say what became of a field and are not failures (FamixOpenApiGapReport class>>informationalKinds)"

	^ FamixOpenApiGapReport informationalKinds
]

{ #category : 'data - findings' }
FamixOpenApiFidelityReport class >> knownImporterFindings [
	"What the checks know about the importer, to read a verdict with: the findings of the value check (FamixOpenApiFieldMapping class>>knownImporterGaps, V8) then those of the extensions check (V9)"

	^ FamixOpenApiFieldMapping knownImporterGaps
	  , self extensionsFindings
]

{ #category : 'data - findings' }
FamixOpenApiFidelityReport class >> notVerified [
	"What no check of the series compares (the end of the report says it, so that a faithful verdict is not read as more than it is)"

	^ #( 'The merged form: a model imported with mergesInlineSchemas = true is not checked (one precondition gap).'
	     'The names of the entities, except where the slot is the source value verbatim.'
	     'The defaults of style and explode of the parameters and headers, and Link.parameters.'
	     'The schema of the formData parameters of Swagger 2 (type file, one property per parameter) and the keywords of a Swagger 2 header (type, format...).'
	     'The inverse relations (usedBy...): the model validator checks their coherence, not against the source.'
	     'The structure inside the value of a key that the metamodel does not model: the extensions are compared as canonical JSON text.'
	     'The nodes of the wrong shape, and what the derivation does not follow (FamixOpenApiSyntheticExpectations class>>knownLimits: a $ref into an extension, clones nested more than 32 deep).'
	     'The relations of the keys beside a $ref of OpenAPI 3.1 (deferred, counted in the coverage).'
	     'That a diagnostic of the importer is justified: it is trusted by its code and its pointer.'
	     'A model imported by another importer than the one the checks were written against, and documents that are not in the corpus of 20 files.' )
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> preconditionKinds [
	"The kinds of gap that say that no check could run: the version of the document is unknown, the model was imported with the inline schemas merged"

	^ #( #preconditionVersion #preconditionMerged )
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> reportNames [
	"The names under which gaps are reported, in this order: the document and the preconditions (nothing could be compared), then the four checks"

	^ #( #document #preconditions ) , self checkNames
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> valueKinds [
	"The kinds of gap of the value check (V8), all failures"

	^ #( #valueMismatch #countMismatch )
]

{ #category : 'data - kinds' }
FamixOpenApiFidelityReport class >> versionPrefixes [
	"The versions of the documents, as they start the keys of the coverage"

	^ #( 'v30' 'v31' 'v2' )
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport class >> writeSection: aTitle on: aStream [
	"A level 2 heading of the markdown summaries, with its blank lines"

	aStream
		lf;
		nextPutAll: '## ';
		nextPutAll: aTitle;
		lf;
		lf
]

{ #category : 'merging' }
FamixOpenApiFidelityReport >> absorb: aReport [

	documents := documents + aReport documents.
	files addAll: aReport files.
	aReport versions do: [ :each | versions addIfNotPresent: each ].
	nodeCount := nodeCount + aReport nodeCount.
	entityCount := entityCount + aReport entityCount.
	aReport checksSkipped do: [ :each | self skip: each ].
	aReport reportsDo: [ :check :each |
		self absorbGapsOf: each intoCheck: check ]
]

{ #category : 'merging' }
FamixOpenApiFidelityReport >> absorbGapsOf: aGapReport intoCheck: aCheckName [
	"Add the gaps, the coverage and the frequencies of aGapReport to the report of the check"

	| merged |
	merged := reports
		          at: aCheckName
		          ifAbsentPut: [ FamixOpenApiGapReport new ].
	aGapReport gaps do: [ :each | merged add: each ].
	merged coverage mergeWith: aGapReport coverage.
	merged extensions mergeWith: aGapReport extensions
]

{ #category : 'recording' }
FamixOpenApiFidelityReport >> addDocumentLabeled: aFileOrNil version: aVersion nodes: aNodeCount entities: anEntityCount [
	"One more document: its label (nil when it has none), its version, the number of nodes of the source and of entities of the model"

	documents := documents + 1.
	aFileOrNil ifNotNil: [ files add: aFileOrNil ].
	versions addIfNotPresent: aVersion.
	nodeCount := nodeCount + aNodeCount.
	entityCount := entityCount + anEntityCount
]

{ #category : 'recording' }
FamixOpenApiFidelityReport >> addReport: aGapReport ofCheck: aCheckName [
	"The gaps of a check that ran (the name is one of #checkNames, #preconditions or #document)"

	reports at: aCheckName put: aGapReport
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> checksRun [
	"The checks that ran, in the order of #checkNames"

	^ self class checkNames select: [ :each | reports includesKey: each ]
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> checksSkipped [
	"The checks that did not run: a precondition failed, or #checks: left them out"

	^ skipped
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> countsByCheckAndKind [
	"A Dictionary check -> (Dictionary kind -> number of gaps), for the checks that have gaps, in the order of FamixOpenApiFidelityReport class>>reportNames, the kinds sorted"

	| counts |
	counts := OrderedDictionary new.
	self class reportNames do: [ :check |
		(self reportOfCheck: check) isEmpty ifFalse: [
			counts at: check put: (self reportOfCheck: check) countsByKind ] ].
	^ counts
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> coverage [
	"The coverage of the checks, merged: the values compared, the relations compared with their targets, the relations deferred with their reason"

	| merged |
	merged := FamixOpenApiCoverage new.
	reports do: [ :each | merged mergeWith: each coverage ].
	^ merged
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> coverageNumbersOf: aVersionPrefix [
	"Values compared, wrong type, no entity, relations compared, targets, mismatched (values and relations), deferred, for the keys of the version"

	^ {
		  (self
			   valuesIn: aVersionPrefix
			   sum: [ :coverage :key | coverage comparedCountOf: key ]).
		  (self
			   valuesIn: aVersionPrefix
			   sum: [ :coverage :key | coverage wrongTypeCountOf: key ]).
		  (self
			   valuesIn: aVersionPrefix
			   sum: [ :coverage :key | coverage withoutEntityCountOf: key ]).
		  (self
			   relationsIn: aVersionPrefix
			   sum: [ :coverage :key | coverage comparedCountOf: key ]).
		  (self
			   relationsIn: aVersionPrefix
			   sum: [ :coverage :key | coverage linkCountOf: key ]).
		  ((self
			    valuesIn: aVersionPrefix
			    sum: [ :coverage :key | coverage mismatchCountOf: key ])
		   + (self
				    relationsIn: aVersionPrefix
				    sum: [ :coverage :key | coverage mismatchCountOf: key ])).
		  (self
			   relationsIn: aVersionPrefix
			   sum: [ :coverage :key | coverage deferredCountOf: key ]) }
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> documents [
	"The number of documents of the report"

	^ documents
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> documentsText [
	"The number of documents, with their labels when there are few"

	^ documents printString , ((files size between: 1 and: 3)
		   ifTrue: [ ' (' , (self namesText: files) , ')' ]
		   ifFalse: [ '' ])
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> entityCount [
	"The number of entities of the imported models"

	^ entityCount
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> failingGaps [
	"The gaps of the kinds of the class side #failingKinds"

	^ self gaps select: [ :each | self isFailing: each ]
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> failingGapsOfCheck: aCheckName [

	^ (self gapsOfCheck: aCheckName) select: [ :each |
		  self isFailing: each ]
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> files [
	"The labels of the documents that have one"

	^ files
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> frequencies [
	"The frequency table of the fields that the metamodel does not model (FamixOpenApiExtensionsReport, V9): what became of them at the import"

	^ (self reportOfCheck: #extensions) extensions
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> gaps [
	"Every gap, in the order of FamixOpenApiFidelityReport class>>reportNames"

	^ self class reportNames flatCollect: [ :each |
		  self gapsOfCheck: each ]
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> gapsOfCheck: aCheckName [
	"The gaps of a check (one of #checkNames, #preconditions, #document), none when it did not run"

	^ (self reportOfCheck: aCheckName) gaps
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> informationalGaps [
	"The gaps of the kinds of the class side #informationalKinds: they say what became of a field"

	^ self gaps select: [ :each |
		  self class informationalKinds includes: each kind ]
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> informationalRows [
	"Arrays check, kind, number of gaps for the informational kinds"

	^ Array streamContents: [ :stream |
		  self countsByCheckAndKind keysAndValuesDo: [ :check :counts |
			  counts keysAndValuesDo: [ :kind :count |
				  (self class informationalKinds includes: kind) ifTrue: [
					  stream nextPut: {
							  check.
							  kind.
							  count } ] ] ] ]
]

{ #category : 'initialization' }
FamixOpenApiFidelityReport >> initialize [

	super initialize.
	files := OrderedCollection new.
	versions := OrderedCollection new.
	documents := 0.
	nodeCount := 0.
	entityCount := 0.
	reports := OrderedDictionary new.
	skipped := OrderedCollection new
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> isFailing: aGap [

	^ self class failingKinds includes: aGap kind
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> isFaithful [
	"True when no check found a failing gap (and no gap is of an unknown kind). Only the checks that ran say something: see #checksRun and #checksSkipped"

	^ self failingGaps isEmpty and: [ self unclassifiedGaps isEmpty ]
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> knownImporterFindings [
	"What the checks know about the importer (class side data)"

	^ self class knownImporterFindings
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> markdownSummary [
	"Markdown of the report: header (files, version, counts), verdict, failing gaps by check and kind (capped, the others are counted), informational counts, coverage per version, candidates to model, known importer findings, what is not verified. Lines end with LF"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: '# Import fidelity report';
			  lf.
		  self writeHeaderOn: stream.
		  self writeVerdictOn: stream.
		  self writeFailingOn: stream.
		  self writeInformationalOn: stream.
		  self writeCoverageOn: stream.
		  self writeCandidatesOn: stream.
		  self writeFindingsOn: stream.
		  self writeNotVerifiedOn: stream ]
]

{ #category : 'merging' }
FamixOpenApiFidelityReport >> mergeWith: anotherReport [
	"A new report of the documents of both: the gaps check by check, the coverage and the frequencies added up (the gaps keep the file they were stamped with). The receiver and the argument are not changed"

	^ self class new
		  absorb: self;
		  absorb: anotherReport;
		  yourself
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> namesText: aCollection [

	^ aCollection
		  ifEmpty: [ 'none' ]
		  ifNotEmpty: [ ', ' join: aCollection ]
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> nodeCount [
	"The number of nodes of the source documents"

	^ nodeCount
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> relationsCoverage [
	"What the relation check compared and deferred (FamixOpenApiCoverage)"

	^ (self reportOfCheck: #relations) coverage
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> relationsIn: aVersionPrefix sum: aBlock [

	^ self sum: aBlock of: self relationsCoverage in: aVersionPrefix
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> reportOfCheck: aCheckName [
	"The FamixOpenApiGapReport of a check, an empty one when the check did not run"

	^ reports at: aCheckName ifAbsent: [ FamixOpenApiGapReport new ]
]

{ #category : 'merging' }
FamixOpenApiFidelityReport >> reportsDo: aBlock [
	"Evaluate aBlock with every check that has a report, and its FamixOpenApiGapReport"

	reports keysAndValuesDo: aBlock
]

{ #category : 'recording' }
FamixOpenApiFidelityReport >> skip: aCheckName [
	"A check that did not run: skipped for a precondition or not selected"

	skipped addIfNotPresent: aCheckName
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> sum: aBlock of: aCoverage in: aVersionPrefix [
	"The sum of aBlock (coverage, key) for the keys of the version of aCoverage (a key starts with its version and a space)"

	| prefix keys |
	prefix := aVersionPrefix , ' '.
	keys := (aCoverage sortedKeys , aCoverage deferredKeys) asSet.
	^ keys inject: 0 into: [ :sum :each |
		  (each beginsWith: prefix)
			  ifTrue: [ sum + (aBlock value: aCoverage value: each) ]
			  ifFalse: [ sum ] ]
]

{ #category : 'gaps' }
FamixOpenApiFidelityReport >> unclassifiedGaps [
	"The gaps of a kind that is neither failing nor informational (none, unless a check got a new kind: then the report is not faithful until the kind is classified)"

	^ self gaps reject: [ :each |
		  (self isFailing: each) or: [
			  self class informationalKinds includes: each kind ] ]
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> valuesCoverage [
	"What the value check compared (FamixOpenApiCoverage)"

	^ (self reportOfCheck: #values) coverage
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> valuesIn: aVersionPrefix sum: aBlock [

	^ self sum: aBlock of: self valuesCoverage in: aVersionPrefix
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> version [
	"The version of the document, #mixed for a report of documents of several versions"

	^ versions size = 1
		  ifTrue: [ versions first ]
		  ifFalse: [ #mixed ]
]

{ #category : 'accessing' }
FamixOpenApiFidelityReport >> versions [
	"The versions of the documents (#v30, #v31, #v2, #unknownVersion), without repetition"

	^ versions
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeBulletsOf: someTexts on: aStream [

	someTexts do: [ :each |
		aStream
			nextPutAll: '- ';
			nextPutAll: each;
			lf ]
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeCandidatesOn: aStream [
	"The fields that the metamodel does not model (structural level) met in the documents, with their frequency"

	self writeSection: 'Candidates to model' on: aStream.
	self frequencies candidatesToModel ifEmpty: [
		aStream
			nextPutAll: 'None.';
			lf.
		^ self ].
	self frequencies
		writeRows: self frequencies candidatesToModel
		on: aStream
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeCoverageOn: aStream [
	"Per version what the value and relation checks compared, and the relations deferred with their reason"

	| prefixes |
	self writeSection: 'Coverage per version' on: aStream.
	prefixes := self class versionPrefixes select: [ :each |
		            versions includes: each asSymbol ].
	prefixes ifEmpty: [
		aStream
			nextPutAll: 'Nothing compared.';
			lf.
		^ self ].
	aStream
		nextPutAll:
			'| Version | Values compared | Wrong type | No entity | Relations compared | Targets | Mismatched | Deferred |';
		lf;
		nextPutAll: '|---|---|---|---|---|---|---|---|';
		lf.
	prefixes do: [ :each | self writeCoverageRowOf: each on: aStream ].
	self relationsCoverage deferredKeys ifNotEmpty: [
		aStream
			lf;
			nextPutAll: self relationsCoverage markdownDeferred ]
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeCoverageRowOf: aVersionPrefix on: aStream [

	aStream
		nextPutAll: '| ';
		nextPutAll: aVersionPrefix.
	(self coverageNumbersOf: aVersionPrefix) do: [ :each |
		aStream
			nextPutAll: ' | ';
			print: each ].
	aStream
		nextPutAll: ' |';
		lf
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeFailingOn: aStream [
	"The failing gaps check by check, grouped by kind, the first ones of every group (the others are counted)"

	self writeSection: 'Failing gaps' on: aStream.
	(self failingGaps isEmpty and: [ self unclassifiedGaps isEmpty ])
		ifTrue: [
			aStream
				nextPutAll: 'None.';
				lf ].
	self class reportNames do: [ :check |
		self
			writeGroupsOf: (self failingGapsOfCheck: check)
			check: check
			on: aStream ].
	self
		writeGroupsOf: self unclassifiedGaps
		check: 'unclassified'
		on: aStream
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeFindingsOn: aStream [
	"What the checks know about the importer: a gap of these kinds is read with them"

	self writeSection: 'Known importer findings' on: aStream.
	self writeBulletsOf: self knownImporterFindings on: aStream
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeGap: aGap on: aStream [
	"One line: the file when it has one, the pointer of the source, the spec object, the message on one line"

	aStream nextPutAll: '- '.
	aGap file ifNotNil: [ :label |
		aStream
			nextPutAll: label;
			space ].
	aStream
		nextPut: $`;
		nextPutAll: aGap sourcePointer asString;
		nextPutAll: '` ';
		nextPutAll: aGap specObject asString;
		nextPutAll: ': ';
		nextPutAll: (' ' join: aGap message asString lines);
		lf
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeGroup: aCollectionOfGaps title: aString on: aStream [
	"The title with the number of gaps, then the first ones, then how many are not listed"

	| shown |
	shown := self class gapsShownPerGroup.
	aStream
		nextPutAll: '### ';
		nextPutAll: aString;
		nextPutAll: ' (';
		print: aCollectionOfGaps size;
		nextPut: $);
		lf;
		lf.
	(aCollectionOfGaps first: (aCollectionOfGaps size min: shown)) do: [
		:each | self writeGap: each on: aStream ].
	aCollectionOfGaps size > shown ifTrue: [
		aStream
			nextPutAll: '- ... and ';
			print: aCollectionOfGaps size - shown;
			nextPutAll: ' more';
			lf ].
	aStream lf
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeGroupsOf: aCollectionOfGaps check: aCheckName on: aStream [

	| groups |
	groups := aCollectionOfGaps groupedBy: [ :each | each kind ].
	groups keys sorted do: [ :kind |
		self
			writeGroup: (groups at: kind)
			title: ('{1} / {2}' format: {
						 aCheckName.
						 kind })
			on: aStream ]
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeHeaderOn: aStream [
	"The documents, their version, the size of the source and of the model, the checks that ran"

	aStream
		lf;
		nextPutAll: '- Documents: ';
		nextPutAll: self documentsText;
		lf;
		nextPutAll: '- Version: ';
		nextPutAll: (self namesText: versions sorted);
		lf;
		nextPutAll: '- Source nodes: ';
		print: nodeCount;
		nextPutAll: '; model entities: ';
		print: entityCount;
		lf;
		nextPutAll: '- Checks run: ';
		nextPutAll: (self namesText: self checksRun);
		nextPutAll: '; skipped: ';
		nextPutAll: (self namesText: skipped);
		lf
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeInformationalOn: aStream [
	"The number of gaps of every informational kind, per check"

	self
		writeSection:
		'Informational gaps (what became of a field, not failures)'
		on: aStream.
	self informationalRows ifEmpty: [
		aStream
			nextPutAll: 'None.';
			lf.
		^ self ].
	aStream
		nextPutAll: '| Check | Kind | Gaps |';
		lf;
		nextPutAll: '|---|---|---|';
		lf.
	self informationalRows do: [ :each |
		aStream
			nextPutAll: '| ';
			nextPutAll: each first;
			nextPutAll: ' | ';
			nextPutAll: each second;
			nextPutAll: ' | ';
			print: each third;
			nextPutAll: ' |';
			lf ]
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeNotVerifiedOn: aStream [
	"What no check compares"

	self writeSection: 'Not verified' on: aStream.
	self writeBulletsOf: self class notVerified on: aStream
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeSection: aTitle on: aStream [

	self class writeSection: aTitle on: aStream
]

{ #category : 'reporting' }
FamixOpenApiFidelityReport >> writeVerdictOn: aStream [
	"One line: faithful, or the number of failing gaps"

	aStream
		lf;
		nextPutAll: (self isFaithful
				 ifTrue: [ '**Verdict: FAITHFUL** (no failing gap)' ]
				 ifFalse: [
					 '**Verdict: NOT FAITHFUL** (failing gaps: '
					 ,
						 (self failingGaps size + self unclassifiedGaps size)
							 printString , ')' ]);
		lf
]
