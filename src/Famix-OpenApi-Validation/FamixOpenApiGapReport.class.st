"
The collection of FamixOpenApiGap found by a fidelity check, shared by the checks of the series (existence V7, values V8, extensions and diagnostics V9, corpus report V10). It answers the gaps, narrowed by kind, and counts them by kind and by spec object. Besides the gaps it holds the statistics a check records to say what it looked at: per spec object the number of source nodes, of entities they should give and of entities found, and per rule the number of entities without source node that the derivation expects (#derivedCountsByRule) and the number of them found in the model (#syntheticCountsByRule). The optional file is the name of the source document: it is stamped on every gap added without one. A value check also records its coverage (#coverage, FamixOpenApiCoverage: what was compared, per field), shown by #markdownSummary, and the gaps of a field are counted by #countsByField.
"
Class {
	#name : 'FamixOpenApiGapReport',
	#superclass : 'Object',
	#instVars : [
		'gaps',
		'file',
		'nodeCounts',
		'expectedCounts',
		'foundCounts',
		'syntheticCounts',
		'derivedCounts',
		'coverage'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'adding' }
FamixOpenApiGapReport >> add: aGap [
	"Add aGap, stamped with the file of the report when it has none. Answer aGap"

	aGap file ifNil: [ aGap file: file ].
	gaps add: aGap.
	^ aGap
]

{ #category : 'value checks' }
FamixOpenApiGapReport >> countMismatches [
	"The gaps about a number of elements that is not the one of the source"

	^ self gapsOfKind: #countMismatch
]

{ #category : 'value checks' }
FamixOpenApiGapReport >> countsByField [
	"A Dictionary 'spec object.field' -> number of gaps, sorted, for the gaps about a field"

	^ self sortedCountsOf:
		  ((gaps select: [ :each | each fieldKey isNotNil ])
			   collect: [ :each |
			   each specObject asString , '.' , each fieldKey ]
			   as: Bag)
]

{ #category : 'counting' }
FamixOpenApiGapReport >> countsByKind [
	"A Dictionary kind -> number of gaps, sorted by kind"

	^ self sortedCountsOf: (gaps collect: #kind as: Bag)
]

{ #category : 'counting' }
FamixOpenApiGapReport >> countsBySpecObject [
	"A Dictionary spec object name -> number of gaps, sorted by name; the gaps without source node count under '-'"

	^ self sortedCountsOf:
		  (gaps collect: [ :each | each specObject ifNil: [ '-' ] ] as: Bag)
]

{ #category : 'value checks' }
FamixOpenApiGapReport >> coverage [
	"What the value check compared (FamixOpenApiCoverage); empty for a check that records none"

	^ coverage
]

{ #category : 'accessing' }
FamixOpenApiGapReport >> derivedCountsByRule [
	"A Dictionary rule name -> number of entities without source node that the rule derives (found or not)"

	^ self sortedCountsOf: derivedCounts
]

{ #category : 'counting' }
FamixOpenApiGapReport >> expectedCountsBySpecObject [
	"A Dictionary spec object name -> number of entities the source nodes should give"

	^ self sortedCountsOf: expectedCounts
]

{ #category : 'accessing' }
FamixOpenApiGapReport >> file [
	"The name of the source document, nil when it is unknown"

	^ file
]

{ #category : 'accessing' }
FamixOpenApiGapReport >> file: aString [

	file := aString
]

{ #category : 'counting' }
FamixOpenApiGapReport >> foundCountsBySpecObject [
	"A Dictionary spec object name -> number of expected entities found in the model"

	^ self sortedCountsOf: foundCounts
]

{ #category : 'querying' }
FamixOpenApiGapReport >> gaps [
	"The gaps in the order they were found"

	^ gaps asArray
]

{ #category : 'querying' }
FamixOpenApiGapReport >> gapsOfKind: aSymbol [

	^ gaps select: [ :each | each kind = aSymbol ]
]

{ #category : 'initialization' }
FamixOpenApiGapReport >> initialize [

	super initialize.
	gaps := OrderedCollection new.
	nodeCounts := Bag new.
	expectedCounts := Bag new.
	foundCounts := Bag new.
	syntheticCounts := Bag new.
	derivedCounts := Bag new.
	coverage := FamixOpenApiCoverage new
]

{ #category : 'testing' }
FamixOpenApiGapReport >> isEmpty [

	^ gaps isEmpty
]

{ #category : 'reporting' }
FamixOpenApiGapReport >> markdownSummary [
	"Markdown tables of the gaps per kind and of the statistics per spec object, the coverage table of a value check, then the list of the gaps. Lines end with LF"

	^ String streamContents: [ :stream |
		  self writeKindTableOn: stream.
		  self writeSpecObjectTableOn: stream.
		  self writeCoverageOn: stream.
		  self writeGapListOn: stream ]
]

{ #category : 'counting' }
FamixOpenApiGapReport >> nodeCountsBySpecObject [
	"A Dictionary spec object name -> number of source nodes looked at"

	^ self sortedCountsOf: nodeCounts
]

{ #category : 'printing' }
FamixOpenApiGapReport >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: gaps size;
		nextPutAll: ' gaps)'
]

{ #category : 'recording' }
FamixOpenApiGapReport >> recordDerived: aRuleName [
	"One entity without source node that the derivation of the rule aRuleName expects, found in the model or not"

	derivedCounts add: aRuleName
]

{ #category : 'adding' }
FamixOpenApiGapReport >> recordNode: aSpecObjectName expected: anExpectedCount found: aFoundCount [
	"One source node of the spec object, the number of entities it should give and the number of them found"

	nodeCounts add: aSpecObjectName.
	expectedCounts add: aSpecObjectName withOccurrences: anExpectedCount.
	foundCounts add: aSpecObjectName withOccurrences: aFoundCount
]

{ #category : 'adding' }
FamixOpenApiGapReport >> recordSynthetic: aRuleName [
	"One entity accepted without source node by the documented rule aRuleName"

	syntheticCounts add: aRuleName
]

{ #category : 'accessing' }
FamixOpenApiGapReport >> size [

	^ gaps size
]

{ #category : 'private' }
FamixOpenApiGapReport >> sortedCountsOf: aBag [

	| counts |
	counts := OrderedDictionary new.
	aBag asSet sorted do: [ :each |
		counts at: each put: (aBag occurrencesOf: each) ].
	^ counts
]

{ #category : 'reporting' }
FamixOpenApiGapReport >> summary [
	"A short plain text: the number of gaps, the count per kind, then per spec object the source nodes, the entities expected and found. Lines end with LF"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: 'gaps: ';
			  print: gaps size;
			  lf.
		  self countsByKind keysAndValuesDo: [ :kind :count |
			  stream
				  nextPutAll: kind asString;
				  nextPutAll: ': ';
				  print: count;
				  lf ].
		  self nodeCountsBySpecObject keysAndValuesDo: [ :name :count |
			  self writeCountsOf: name nodes: count on: stream ] ]
]

{ #category : 'counting' }
FamixOpenApiGapReport >> syntheticCountsByRule [
	"A Dictionary rule name -> number of entities accepted by the rule"

	^ self sortedCountsOf: syntheticCounts
]

{ #category : 'value checks' }
FamixOpenApiGapReport >> valueMismatches [
	"The gaps about a value of a slot that is not the one of the source"

	^ self gapsOfKind: #valueMismatch
]

{ #category : 'private' }
FamixOpenApiGapReport >> writeCountsOf: aSpecObjectName nodes: aCount on: aStream [

	aStream
		nextPutAll: aSpecObjectName;
		nextPutAll: ': nodes ';
		print: aCount;
		nextPutAll: ', entities expected ';
		print: (expectedCounts occurrencesOf: aSpecObjectName);
		nextPutAll: ', found ';
		print: (foundCounts occurrencesOf: aSpecObjectName);
		lf
]

{ #category : 'value checks' }
FamixOpenApiGapReport >> writeCoverageOn: aStream [
	"The coverage tables of the value check, when there is one: the fields compared, then the keys beside a $ref that were ignored"

	coverage isEmpty ifTrue: [ ^ self ].
	aStream
		lf;
		nextPutAll: coverage markdownTable.
	coverage ignoredSiblingKeys ifEmpty: [ ^ self ].
	aStream
		lf;
		nextPutAll: coverage markdownIgnoredSiblings
]

{ #category : 'private' }
FamixOpenApiGapReport >> writeGapListOn: aStream [

	gaps isEmpty ifTrue: [ ^ self ].
	aStream
		lf;
		nextPutAll: 'Gaps (';
		print: gaps size;
		nextPutAll: '):';
		lf;
		lf.
	gaps do: [ :each |
		aStream
			nextPutAll: '- `';
			nextPutAll: each sourcePointer asString;
			nextPutAll: '` ';
			nextPutAll: each kind asString;
			nextPutAll: ' ';
			nextPutAll: each specObject asString;
			nextPutAll: ': ';
			nextPutAll: each message asString;
			lf ]
]

{ #category : 'private' }
FamixOpenApiGapReport >> writeKindTableOn: aStream [

	aStream
		nextPutAll: '| Kind | Gaps |';
		lf;
		nextPutAll: '|---|---|';
		lf.
	self countsByKind keysAndValuesDo: [ :kind :count |
		aStream
			nextPutAll: '| ';
			nextPutAll: kind asString;
			nextPutAll: ' | ';
			print: count;
			nextPutAll: ' |';
			lf ]
]

{ #category : 'private' }
FamixOpenApiGapReport >> writeSpecObjectTableOn: aStream [

	aStream
		lf;
		nextPutAll: '| Spec object | Nodes | Expected | Found |';
		lf;
		nextPutAll: '|---|---|---|---|';
		lf.
	self nodeCountsBySpecObject keysAndValuesDo: [ :name :count |
		aStream
			nextPutAll: '| ';
			nextPutAll: name;
			nextPutAll: ' | ';
			print: count;
			nextPutAll: ' | ';
			print: (expectedCounts occurrencesOf: name);
			nextPutAll: ' | ';
			print: (foundCounts occurrencesOf: name);
			nextPutAll: ' |';
			lf ]
]
