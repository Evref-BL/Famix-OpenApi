"
How many times a field of a spec object of a version (#v30, #v31, #v2) was met in the source documents, by what became of it at the import (V9): the count per kind (FamixOpenApiFieldFrequency class>>kinds: #onlyInExtensions, #ignoredByDiagnostic, #lost, #silentDrop, #valueKeptAnyway, #valueMismatch, #notDecidable, and #deferred for the fields of relations and implicit fields, which V10 classifies) and the codes of the importer diagnostics that were found to cover it. The field is a key of the source ('x-*' for every extension key, a key beside a $ref is written 'key (beside $ref)'). #total counts the kinds classified by V9, #deferredCount the others.
"
Class {
	#name : 'FamixOpenApiFieldFrequency',
	#superclass : 'Object',
	#instVars : [
		'version',
		'specObject',
		'field',
		'counts',
		'codes'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiFieldFrequency class >> kinds [
	"The kinds a source occurrence of a field is counted under. Informational (the importer says it or keeps the value): #onlyInExtensions, #ignoredByDiagnostic, #valueKeptAnyway, #notDecidable (no diagnostics were given). Failing: #lost, #silentDrop, #valueMismatch. #deferred is for V10 (relations, implicit fields)"

	^ #( #onlyInExtensions #ignoredByDiagnostic #lost #silentDrop
	     #valueKeptAnyway #valueMismatch #notDecidable #deferred )
]

{ #category : 'instance creation' }
FamixOpenApiFieldFrequency class >> version: aVersion specObject: aSpecObjectName field: aFieldName [

	^ self new
		  version: aVersion;
		  specObject: aSpecObjectName;
		  field: aFieldName;
		  yourself
]

{ #category : 'recording' }
FamixOpenApiFieldFrequency >> absorb: anotherFrequency [
	"Add the counts and the codes of another frequency of the same field"

	anotherFrequency class kinds do: [ :kind |
		counts add: kind withOccurrences: (anotherFrequency countOf: kind) ].
	codes addAll: anotherFrequency codes
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> codes [
	"The codes of the diagnostics that covered occurrences of the field, sorted"

	^ codes asArray sorted
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> countOf: aKind [

	^ counts occurrencesOf: aKind
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> deferredCount [
	"The occurrences left to V10"

	^ self countOf: #deferred
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> field [

	^ field
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> field: aString [

	field := aString
]

{ #category : 'initialization' }
FamixOpenApiFieldFrequency >> initialize [

	super initialize.
	counts := Bag new.
	codes := Set new
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> key [
	"What identifies the field in a table"

	^ {
		  version.
		  specObject.
		  field }
]

{ #category : 'printing' }
FamixOpenApiFieldFrequency >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: version asString;
		space;
		nextPutAll: specObject asString;
		nextPut: $.;
		nextPutAll: field asString;
		space;
		print: counts size;
		nextPut: $)
]

{ #category : 'recording' }
FamixOpenApiFieldFrequency >> recordKind: aKind code: aCodeOrNil [
	"One occurrence of the field, and the code of the diagnostic that covers it (nil for none)"

	counts add: aKind.
	aCodeOrNil ifNotNil: [ codes add: aCodeOrNil ]
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> sortKey [
	"A text to sort the frequencies by version, spec object and field"

	^ ' ' join: self key
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> specObject [

	^ specObject
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> specObject: aString [

	specObject := aString
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> total [
	"The occurrences classified by V9 (every kind but #deferred)"

	^ counts size - self deferredCount
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> version [

	^ version
]

{ #category : 'accessing' }
FamixOpenApiFieldFrequency >> version: aVersion [

	version := aVersion
]
