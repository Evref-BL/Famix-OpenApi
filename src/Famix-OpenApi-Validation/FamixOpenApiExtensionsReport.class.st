"
The FREQUENCY table of the extensions check (V9): per version, spec object and field of the source, how many occurrences were met and what became of them (a FamixOpenApiFieldFrequency each: kept in the extensions, reported by a diagnostic, lost, ...). It is recorded by FamixOpenApiExtensionsCheck, kept by FamixOpenApiGapReport>>extensions, merged over several documents with #mergeWith:, and answers #topFields:, #countsByKind, #frequencyOf:field:in: and #markdownSummary (LF line ends): the table sorted by the number of occurrences classified by V9, the CANDIDATES TO MODEL (the fields the metamodel does not model, of the structural level of FamixOpenApiSpecFieldTable, with their frequency) and the fields that were NEVER SEEN. The conformance rows of the not modelled fields (#notModelledRows:) are given by the check: the table does not know the metamodel.
"
Class {
	#name : 'FamixOpenApiExtensionsReport',
	#superclass : 'Object',
	#instVars : [
		'fields',
		'notModelledRows'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'candidates' }
FamixOpenApiExtensionsReport >> candidatesToModel [
	"The rows of the fields the metamodel does not model, of the structural level, that were met in the documents, the most frequent first"

	^ (self notModelledRowsSeen: true) select: [ :each |
		  each level == #structural ]
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> countsByKind [
	"A Dictionary kind -> number of occurrences, in the order of FamixOpenApiFieldFrequency class>>kinds, for the kinds that have some"

	| counts |
	counts := OrderedDictionary new.
	FamixOpenApiFieldFrequency kinds do: [ :kind |
		| count |
		count := fields values sumNumbers: [ :each | each countOf: kind ].
		count > 0 ifTrue: [ counts at: kind put: count ] ].
	^ counts
]

{ #category : 'recording' }
FamixOpenApiExtensionsReport >> ensureFrequencyOf: aSpecObjectName field: aFieldName in: aVersion [
	"The frequency of the field of the spec object in the version, created when there is none: the one to record an occurrence on (#recordKind:code:)"

	^ fields
		  at: {
				  aVersion.
				  aSpecObjectName.
				  aFieldName }
		  ifAbsentPut: [
			  FamixOpenApiFieldFrequency
				  version: aVersion
				  specObject: aSpecObjectName
				  field: aFieldName ]
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> frequencyOf: aSpecObjectName field: aFieldName in: aVersion [
	"The frequency of the field of the spec object in the version: a frequency of nothing when the field was never met"

	^ fields
		  at: {
				  aVersion.
				  aSpecObjectName.
				  aFieldName }
		  ifAbsent: [
			  FamixOpenApiFieldFrequency
				  version: aVersion
				  specObject: aSpecObjectName
				  field: aFieldName ]
]

{ #category : 'candidates' }
FamixOpenApiExtensionsReport >> frequencyOfRow: aConformanceRow [
	"The frequency of the field of a conformance row"

	^ self
		  frequencyOf: aConformanceRow specObject
		  field: aConformanceRow fieldName
		  in: aConformanceRow version
]

{ #category : 'initialization' }
FamixOpenApiExtensionsReport >> initialize [

	super initialize.
	fields := Dictionary new.
	notModelledRows := #(  )
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> isEmpty [

	^ fields isEmpty
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> markdownSummary [
	"Markdown: the counts per kind, the fields classified by V9 (most frequent first), the candidates to model, the fields never seen, the fields deferred to V10. Lines end with LF"

	^ String streamContents: [ :stream |
		  self writeKindsOn: stream.
		  self
			  writeTableOf: self sortedFields
			  title: 'Fields classified (V9)'
			  on: stream.
		  self writeCandidatesOn: stream.
		  self writeNeverSeenOn: stream.
		  self writeDeferredOn: stream ]
]

{ #category : 'merging' }
FamixOpenApiExtensionsReport >> mergeWith: anotherReport [
	"Add the occurrences of another report (the documents of a corpus), and keep its not modelled rows"

	anotherReport sortedAllFields do: [ :each |
		(self
			 ensureFrequencyOf: each specObject
			 field: each field
			 in: each version) absorb: each ].
	notModelledRows := notModelledRows ifEmpty: [
		                   anotherReport notModelledRows ]
]

{ #category : 'candidates' }
FamixOpenApiExtensionsReport >> neverSeen [
	"The rows of the fields the metamodel does not model that no document has (frequency 0), by version, spec object and field"

	^ self notModelledRowsSeen: false
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> notModelledRows [
	"The conformance rows of the fields the metamodel does not model"

	^ notModelledRows
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> notModelledRows: aCollection [

	notModelledRows := aCollection
]

{ #category : 'candidates' }
FamixOpenApiExtensionsReport >> notModelledRowsSeen: aBoolean [
	"The not modelled rows that were met (the most frequent first), or the ones that were not (by version, spec object and field)"

	| selected |
	selected := notModelledRows select: [ :each |
		            (self frequencyOfRow: each) total > 0 = aBoolean ].
	^ selected sorted: [ :a :b |
		  | totalA totalB |
		  totalA := (self frequencyOfRow: a) total.
		  totalB := (self frequencyOfRow: b) total.
		  totalA > totalB or: [
			  totalA = totalB and: [
				  (self sortKeyOfRow: a) <= (self sortKeyOfRow: b) ] ] ]
]

{ #category : 'candidates' }
FamixOpenApiExtensionsReport >> sortKeyOfRow: aConformanceRow [
	"A text to sort the rows by version, spec object and field"

	^ ' ' join: {
			  aConformanceRow version.
			  aConformanceRow specObject.
			  aConformanceRow fieldName }
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> sortedAllFields [
	"Every frequency, deferred ones included, by version, spec object and field"

	^ fields values sorted: [ :a :b | a sortKey <= b sortKey ]
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> sortedFields [
	"The frequencies that have occurrences classified by V9, the most frequent first (then by version, spec object and field)"

	^ (fields values select: [ :each | each total > 0 ]) sorted: [ :a :b |
		  a total > b total or: [
			  a total = b total and: [ a sortKey <= b sortKey ] ] ]
]

{ #category : 'accessing' }
FamixOpenApiExtensionsReport >> topFields: aCount [
	"The aCount most frequent fields (those classified by V9)"

	^ self sortedFields first: (aCount min: self sortedFields size)
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> writeCandidatesOn: aStream [
	"The structural fields that the metamodel does not model, with the number of times they were met and what became of them"

	aStream
		lf;
		nextPutAll:
			'Candidates to model in the metamodel (not modelled, structural level, met in the documents; ';
		print: self candidatesToModel size;
		nextPutAll: '):';
		lf;
		lf.
	self writeRows: self candidatesToModel on: aStream
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> writeDeferredOn: aStream [
	"The fields of relations and implicit fields, counted for V10"

	self
		writeTableOf:
			((fields values select: [ :each | each deferredCount > 0 ])
				 sorted: [ :a :b | a deferredCount > b deferredCount ])
		title:
		'Deferred to V10 (relations, implicit fields, slots not compared)'
		on: aStream
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> writeKindsOn: aStream [

	aStream
		nextPutAll: '| Kind | Occurrences |';
		lf;
		nextPutAll: '|---|---|';
		lf.
	self countsByKind keysAndValuesDo: [ :kind :count |
		aStream
			nextPutAll: '| ';
			nextPutAll: kind;
			nextPutAll: ' | ';
			print: count;
			nextPutAll: ' |';
			lf ]
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> writeNeverSeenOn: aStream [
	"The fields that the metamodel does not model and that no document has"

	aStream
		lf;
		nextPutAll: 'Not modelled and never seen in the documents (';
		print: self neverSeen size;
		nextPutAll: '):';
		lf;
		lf.
	self writeRows: self neverSeen on: aStream
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> writeRowOf: aFrequency on: aStream [

	aStream
		nextPutAll: '| ';
		nextPutAll: aFrequency version;
		nextPutAll: ' | `';
		nextPutAll: aFrequency specObject;
		nextPut: $.;
		nextPutAll: aFrequency field;
		nextPutAll: '` | ';
		print: aFrequency total;
		nextPutAll: ' |'.
	FamixOpenApiFieldFrequency kinds do: [ :kind |
		aStream
			space;
			print: (aFrequency countOf: kind);
			nextPutAll: ' |' ].
	aStream
		space;
		nextPutAll: (', ' join: aFrequency codes);
		nextPutAll: ' |';
		lf
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> writeRows: aCollectionOfConformanceRows on: aStream [
	"One table of the not modelled fields: level, occurrences, kept in the extensions, lost"

	aStream
		nextPutAll:
			'| Version | Field | Level | Occurrences | onlyInExtensions | lost |';
		lf;
		nextPutAll: '|---|---|---|---|---|---|';
		lf.
	aCollectionOfConformanceRows do: [ :each |
		| frequency |
		frequency := self frequencyOfRow: each.
		aStream
			nextPutAll: '| ';
			nextPutAll: each version;
			nextPutAll: ' | `';
			nextPutAll: each specObject;
			nextPut: $.;
			nextPutAll: each fieldName;
			nextPutAll: '` | ';
			nextPutAll: each level;
			nextPutAll: ' | ';
			print: frequency total;
			nextPutAll: ' | ';
			print: (frequency countOf: #onlyInExtensions);
			nextPutAll: ' | ';
			print: (frequency countOf: #lost);
			nextPutAll: ' |';
			lf ]
]

{ #category : 'reporting' }
FamixOpenApiExtensionsReport >> writeTableOf: aCollection title: aString on: aStream [
	"The frequencies as a table: the count of every kind, then the diagnostics that cover the field"

	aStream
		lf;
		nextPutAll: aString;
		nextPutAll: ' (';
		print: aCollection size;
		nextPutAll: '):';
		lf;
		lf;
		nextPutAll: '| Version | Field | Total |'.
	FamixOpenApiFieldFrequency kinds do: [ :kind |
		aStream
			nextPutAll: ' ';
			nextPutAll: kind;
			nextPutAll: ' |' ].
	aStream
		nextPutAll: ' Diagnostics |';
		lf;
		nextPutAll: '|---|---|---|'.
	FamixOpenApiFieldFrequency kinds do: [ :kind |
		aStream nextPutAll: '---|' ].
	aStream
		nextPutAll: '---|';
		lf.
	aCollection do: [ :each | self writeRowOf: each on: aStream ]
]
