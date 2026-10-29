"
I am the result of FamixOpenApiMetamodelConformance check: one FamixOpenApiConformanceRow per field of the spec field table and per version, plus one FamixOpenApiModelOnlyRow per slot or relation of the metamodel that corresponds to no spec field.
API: rows, rowsWithStatus:, rowsAt:withStatus:, rowsIn:, notModelledIn:, uncoveredStructural, summary, countAt:level:status:, modelOnlyRows, unexplainedModelOnlyRows, markdownSummary (LF line endings; it writes nothing on disk).
Levels and versions are the ones of FamixOpenApiSpecFieldTable; statuses are #modelledSlot #modelledRelation #implicit #notModelled #notApplicable.
"
Class {
	#name : 'FamixOpenApiConformanceReport',
	#superclass : 'Object',
	#instVars : [
		'rows',
		'modelOnlyRows'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiConformanceReport class >> rows: someConformanceRows modelOnlyRows: someModelOnlyRows [

	^ self new
		  setRows: someConformanceRows modelOnlyRows: someModelOnlyRows;
		  yourself
]

{ #category : 'summary' }
FamixOpenApiConformanceReport >> countAt: aVersion level: aLevel status: aStatus [

	^ self summary
		  at: {
				  aVersion.
				  aLevel.
				  aStatus }
		  ifAbsent: [ 0 ]
]

{ #category : 'markdown' }
FamixOpenApiConformanceReport >> escaped: aString [
	"Answer aString safe in a Markdown table cell."

	^ aString copyReplaceAll: '|' with: '\|'
]

{ #category : 'markdown' }
FamixOpenApiConformanceReport >> markdownSummary [
	"Answer a Markdown String: the counts and one table per version (object, field, level, status, OP target, note), then the model-only slots. Lines are separated by LF; nothing is written on disk."

	^ String streamContents: [ :stream |
		  stream nextPutAll:
			  '# Metamodel conformance to the OpenAPI specifications'.
		  self writeLineOn: stream.
		  FamixOpenApiSpecFieldTable versions do: [ :version |
			  self writeVersion: version on: stream ].
		  self writeModelOnlyOn: stream ]
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> modelOnlyRows [
	"One row per slot or relation of the metamodel that corresponds to no spec field."

	^ modelOnlyRows
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> notModelledIn: aVersion [

	^ (self rowsIn: aVersion) select: [ :each | each isNotModelled ]
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> rows [
	"One row per field and per version, in the order of the field table."

	^ rows
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> rowsAt: aLevel withStatus: aStatus [

	^ rows select: [ :each |
		  each level = aLevel and: [ each status = aStatus ] ]
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> rowsIn: aVersion [

	^ rows select: [ :each | each version = aVersion ]
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> rowsWithStatus: aStatus [

	^ rows select: [ :each | each status = aStatus ]
]

{ #category : 'initialization' }
FamixOpenApiConformanceReport >> setRows: someConformanceRows modelOnlyRows: someModelOnlyRows [

	rows := someConformanceRows.
	modelOnlyRows := someModelOnlyRows
]

{ #category : 'summary' }
FamixOpenApiConformanceReport >> summary [
	"Answer a Dictionary { version. level. status } -> number of rows; combinations without row are absent."

	| counts |
	counts := Dictionary new.
	rows do: [ :each |
		counts
			at: each summaryKey
			put: (counts at: each summaryKey ifAbsent: [ 0 ]) + 1 ].
	^ counts
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> uncoveredStructural [
	"The structural fields (all versions) that the metamodel does not model."

	^ self rowsAt: #structural withStatus: #notModelled
]

{ #category : 'querying' }
FamixOpenApiConformanceReport >> unexplainedModelOnlyRows [

	^ modelOnlyRows select: [ :each | each status = #unexplained ]
]

{ #category : 'markdown' }
FamixOpenApiConformanceReport >> writeCountsOf: aVersion on: aStream [

	#( #structural #useful #metadata ) do: [ :level |
		aStream
			nextPutAll: '- ';
			nextPutAll: level;
			nextPutAll: ':'.
		#( #modelledSlot #modelledRelation #implicit #notModelled
		   #notApplicable ) do: [ :status |
			aStream
				nextPut: Character space;
				nextPutAll: status;
				nextPut: $=;
				print: (self countAt: aVersion level: level status: status) ].
		aStream nextPut: Character lf ].
	aStream nextPut: Character lf
]

{ #category : 'markdown' }
FamixOpenApiConformanceReport >> writeLineOn: aStream [

	aStream
		nextPut: Character lf;
		nextPut: Character lf
]

{ #category : 'markdown' }
FamixOpenApiConformanceReport >> writeModelOnlyOn: aStream [

	aStream nextPutAll: '## Model-only slots'.
	self writeLineOn: aStream.
	aStream
		nextPutAll: '| slot | status | reason |';
		nextPut: Character lf;
		nextPutAll: '|---|---|---|';
		nextPut: Character lf.
	modelOnlyRows do: [ :each |
		aStream
			nextPutAll: '| ';
			nextPutAll: each key;
			nextPutAll: ' | ';
			nextPutAll: each status;
			nextPutAll: ' | ';
			nextPutAll: (self escaped: each reason);
			nextPutAll: ' |';
			nextPut: Character lf ]
]

{ #category : 'markdown' }
FamixOpenApiConformanceReport >> writeRow: aRow on: aStream [

	aRow cellTexts do: [ :each |
		aStream
			nextPutAll: '| ';
			nextPutAll: (self escaped: each);
			nextPut: Character space ].
	aStream
		nextPut: $|;
		nextPut: Character lf
]

{ #category : 'markdown' }
FamixOpenApiConformanceReport >> writeVersion: aVersion on: aStream [

	aStream
		nextPutAll: '## ';
		nextPutAll: (FamixOpenApiSpecFieldTable versionLabelFor: aVersion).
	self writeLineOn: aStream.
	self writeCountsOf: aVersion on: aStream.
	aStream
		nextPutAll: '| object | field | level | status | OP target | note |';
		nextPut: Character lf;
		nextPutAll: '|---|---|---|---|---|---|';
		nextPut: Character lf.
	(self rowsIn: aVersion) do: [ :each |
		self writeRow: each on: aStream ].
	aStream nextPut: Character lf
]
