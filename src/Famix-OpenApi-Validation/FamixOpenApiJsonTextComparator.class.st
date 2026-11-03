"
Comparator #jsonText: a field whose value is any JSON value (enum, default, const and example of a schema, the value of an example, the requestBody of a link) and that the importer stores as JSON TEXT in the slot (VERIFIED: a string ""x"" is stored as '""x""', null as 'null', an object as its JSON text, an absent key as nil). Both sides are normalised to a canonical text: the keys of the objects are sorted, a number that is a whole number is written without fraction (1 and 1.0 are the same), the text of the slot is parsed first. An absent key is nil. Any JSON type fits.
"
Class {
	#name : 'FamixOpenApiJsonTextComparator',
	#superclass : 'FamixOpenApiValueComparator',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'canonical text' }
FamixOpenApiJsonTextComparator class >> canonicalTextOf: aJsonValue [
	"The text of the JSON value with the keys of the objects sorted and the whole numbers written without fraction: two values that mean the same give the same text"

	^ String streamContents: [ :stream |
		  self write: aJsonValue on: stream ]
]

{ #category : 'accessing' }
FamixOpenApiJsonTextComparator class >> comparatorNames [

	^ #( #jsonText )
]

{ #category : 'canonical text' }
FamixOpenApiJsonTextComparator class >> numberTextOf: aNumber [
	"A whole number is written without fraction: 1 and 1.0 are the same value"

	^ (aNumber isInteger or: [
		   aNumber isFinite and: [ aNumber fractionPart = 0 ] ])
		  ifTrue: [ aNumber truncated printString ]
		  ifFalse: [ aNumber printString ]
]

{ #category : 'canonical text' }
FamixOpenApiJsonTextComparator class >> write: aJsonValue on: aStream [

	aJsonValue ifNil: [ ^ aStream nextPutAll: 'null' ].
	aJsonValue isDictionary ifTrue: [
		^ self writeObject: aJsonValue on: aStream ].
	aJsonValue isString ifTrue: [
		^ aStream nextPutAll: (NeoJSONWriter toString: aJsonValue) ].
	aJsonValue isArray ifTrue: [
		^ self writeArray: aJsonValue on: aStream ].
	aJsonValue isNumber ifTrue: [
		^ aStream nextPutAll: (self numberTextOf: aJsonValue) ].
	aStream print: aJsonValue
]

{ #category : 'canonical text' }
FamixOpenApiJsonTextComparator class >> writeArray: anArray on: aStream [

	aStream nextPut: $[.
	anArray
		do: [ :each | self write: each on: aStream ]
		separatedBy: [ aStream nextPut: $, ].
	aStream nextPut: $]
]

{ #category : 'canonical text' }
FamixOpenApiJsonTextComparator class >> writeObject: aDictionary on: aStream [

	aStream nextPut: ${.
	aDictionary keys sorted
		do: [ :key |
			aStream
				nextPutAll: (NeoJSONWriter toString: key);
				nextPut: $:.
			self write: (aDictionary at: key) on: aStream ]
		separatedBy: [ aStream nextPut: $, ].
	aStream nextPut: $}
]

{ #category : 'comparing' }
FamixOpenApiJsonTextComparator >> aDifferentValueFrom: anExpectedText [

	^ anExpectedText
		  ifNil: [ '"mutant"' ]
		  ifNotNil: [ '[' , anExpectedText , ']' ]
]

{ #category : 'comparing' }
FamixOpenApiJsonTextComparator >> expectedOf: aNode rule: aRule context: aContext [
	"The canonical text of the value, nil when the source does not have the key (a null is a value: 'null')"

	^ (aNode includesKey: aRule fieldKey)
		  ifTrue: [
		  self class canonicalTextOf: (aNode valueAt: aRule fieldKey) ]
		  ifFalse: [ nil ]
]

{ #category : 'comparing' }
FamixOpenApiJsonTextComparator >> foundFrom: aSlotText [
	"The canonical text of the JSON the slot holds, nil for nil; a text that is not JSON stays as it is"

	aSlotText ifNil: [ ^ nil ].
	aSlotText isString ifFalse: [ ^ aSlotText printString ].
	^ [
	  self class canonicalTextOf: (NeoJSONReader fromString: aSlotText) ]
		  on: NeoJSONParseError
		  do: [ :error | aSlotText ]
]
