"
What a value check really verified, per key (a String such as 'v30 Info.title -> OPInfo>>title', see FamixOpenApiValueRule>>coverageKeyIn:): how many values were COMPARED, how many of them did not match (a #valueMismatch gap), how many were left out because the source value has a JSON type that does not fit the field (the importer reports it and does not store it) and how many because the entity that should carry the slot is not in the model (the existence check reports it). A field with no count at all was never met in the documents checked. It is the main result of the value check besides the gaps: it says what a check without gap has verified.
"
Class {
	#name : 'FamixOpenApiCoverage',
	#superclass : 'Object',
	#instVars : [
		'compared',
		'mismatched',
		'wrongType',
		'withoutEntity',
		'informative',
		'ignoredSiblings'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'accessing' }
FamixOpenApiCoverage >> comparedCountOf: aKey [

	^ compared occurrencesOf: aKey
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> comparedKeys [
	"The keys of the fields with at least one value compared, sorted"

	^ compared asSet asArray sorted
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> ignoredSiblingCountOf: aKey [

	^ ignoredSiblings occurrencesOf: aKey
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> ignoredSiblingKeys [
	"The keys met beside the $ref of a schema that is only a reference, not compared, sorted"

	^ ignoredSiblings asSet asArray sorted
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> informativeCountOf: aKey [
	"The values compared that were not nil, false or empty"

	^ informative occurrencesOf: aKey
]

{ #category : 'initialization' }
FamixOpenApiCoverage >> initialize [

	super initialize.
	compared := Bag new.
	mismatched := Bag new.
	wrongType := Bag new.
	withoutEntity := Bag new.
	informative := Bag new.
	ignoredSiblings := Bag new
]

{ #category : 'testing' }
FamixOpenApiCoverage >> isEmpty [
	"True when the check met nothing: no value compared, no value of a wrong JSON type, no field without an entity and no sibling of a $ref ignored (a mismatch is a value compared, so it is not counted apart)"

	^ compared isEmpty and: [
		  wrongType isEmpty and: [
			  withoutEntity isEmpty and: [ ignoredSiblings isEmpty ] ] ]
]

{ #category : 'printing' }
FamixOpenApiCoverage >> markdownIgnoredSiblings [
	"A Markdown table of the keys beside a $ref that were not compared (ignored sibling of $ref), empty text when there is none. Lines end with LF"

	^ String streamContents: [ :stream |
		  self ignoredSiblingKeys ifNotEmpty: [ :keys |
			  stream
				  nextPutAll: '| Ignored sibling of $ref | Count |';
				  lf;
				  nextPutAll: '|---|---|';
				  lf.
			  keys do: [ :key |
				  stream
					  nextPutAll: '| ';
					  nextPutAll: key;
					  nextPutAll: ' | ';
					  print: (self ignoredSiblingCountOf: key);
					  nextPutAll: ' |';
					  lf ] ] ]
]

{ #category : 'printing' }
FamixOpenApiCoverage >> markdownTable [
	"A Markdown table, one row per field met, with the counts. Lines end with LF"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll:
				  '| Field | Compared | Not default | Mismatched | Wrong type | No entity |';
			  lf;
			  nextPutAll: '|---|---|---|---|---|---|';
			  lf.
		  self sortedKeys do: [ :key | self writeRowOf: key on: stream ] ]
]

{ #category : 'recording' }
FamixOpenApiCoverage >> mergeWith: aCoverage [
	"Add the counts of aCoverage (the corpus report adds the coverage of every file)"

	aCoverage sortedKeys do: [ :key |
		compared add: key withOccurrences: (aCoverage comparedCountOf: key).
		mismatched
			add: key
			withOccurrences: (aCoverage mismatchCountOf: key).
		wrongType
			add: key
			withOccurrences: (aCoverage wrongTypeCountOf: key).
		informative
			add: key
			withOccurrences: (aCoverage informativeCountOf: key).
		withoutEntity
			add: key
			withOccurrences: (aCoverage withoutEntityCountOf: key) ].
	aCoverage ignoredSiblingKeys do: [ :key |
		ignoredSiblings
			add: key
			withOccurrences: (aCoverage ignoredSiblingCountOf: key) ]
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> mismatchCountOf: aKey [

	^ mismatched occurrencesOf: aKey
]

{ #category : 'recording' }
FamixOpenApiCoverage >> recordCompared: aKey [
	"One value of the field was compared with the slot"

	compared add: aKey
]

{ #category : 'recording' }
FamixOpenApiCoverage >> recordIgnoredSibling: aKey [
	"One key beside the $ref of a schema that is only a reference (OpenAPI 3.0, Swagger 2) was not compared: the importer ignores it, as the spec requires"

	ignoredSiblings add: aKey
]

{ #category : 'recording' }
FamixOpenApiCoverage >> recordInformative: aKey [
	"One value compared was not a default (not nil, false or empty): a comparison that could not pass by chance"

	informative add: aKey
]

{ #category : 'recording' }
FamixOpenApiCoverage >> recordMismatch: aKey [
	"One of the values compared did not match"

	mismatched add: aKey
]

{ #category : 'recording' }
FamixOpenApiCoverage >> recordWithoutEntity: aKey [
	"One value was not compared: the model has no entity to carry the slot"

	withoutEntity add: aKey
]

{ #category : 'recording' }
FamixOpenApiCoverage >> recordWrongType: aKey [
	"One value was not compared: the source value has a JSON type that does not fit the field"

	wrongType add: aKey
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> sortedKeys [
	"The keys with at least one count, sorted"

	^ (compared asSet
		   addAll: wrongType;
		   addAll: withoutEntity;
		   yourself) asArray sorted
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> totalCompared [
	"The number of values compared, all fields together"

	^ compared size
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> totalIgnoredSiblings [

	^ ignoredSiblings size
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> totalInformative [

	^ informative size
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> totalMismatched [

	^ mismatched size
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> withoutEntityCountOf: aKey [

	^ withoutEntity occurrencesOf: aKey
]

{ #category : 'printing' }
FamixOpenApiCoverage >> writeRowOf: aKey on: aStream [

	aStream
		nextPutAll: '| ';
		nextPutAll: aKey;
		nextPutAll: ' | ';
		print: (self comparedCountOf: aKey);
		nextPutAll: ' | ';
		print: (self informativeCountOf: aKey);
		nextPutAll: ' | ';
		print: (self mismatchCountOf: aKey);
		nextPutAll: ' | ';
		print: (self wrongTypeCountOf: aKey);
		nextPutAll: ' | ';
		print: (self withoutEntityCountOf: aKey);
		nextPutAll: ' |';
		lf
]

{ #category : 'accessing' }
FamixOpenApiCoverage >> wrongTypeCountOf: aKey [

	^ wrongType occurrencesOf: aKey
]
